# Continuous Integration

Our working process relies on our CI in many places. We do the following things with CI:

* Run unit tests
* Validate project seeds
* Validate introduced migrations against current DB from production
* Build docker images
* Run cucumber tests
* Deploy new versions
* Perform DB backups

For each step, we have a script, defined as [bin](https://github.com/howtohireme/give-me-poc/tree/master/bin) directory of the project.

## Pipeline

We organize all those things as a pipeline, and its example is available on the [following screenshot](https://monosnap.com/file/0gPd5iAHuewAi36xExMCFGHs6nZPj6).
The pipeline is divided into several stages, and all stages are executed sequentially. Each stage may include several jobs, which are executed in parallel.

In the example from the link you can see, that the `tests` stage includes 3 jobs, that can be run in parallel to speed up build time.

Our CI would start the next stage only if all jobs from previous stages finished successfully.
Such an approach prevents us from using redundant resources if the code has some obvious problem that was found on `tests` stage.

## Travis

We use [Travis](https://travis-ci.org/howtohireme/give-me-poc) as our CI service.
All required configuration is defined at [.travis.yml](https://github.com/howtohireme/give-me-poc/blob/master/.travis.yml) file at the repository.
It allows us to install additional software, define the order of stages and jobs within the stage.
Also, we can define conditional stages, which are executed on specific conditions.

## Jobs

### Unit tests

Unit tests job is the most important for the daily developer's work.
It is executed almost on every event and runs first to provide fast feedback to the developer.
We run it on `pr` and `push` events and skip the `cron` event.
So each time you push some commits to the remote repository, it triggers tests stage.
For this job we require `PostgreSQL` and `redis` to be installed, also we install [code climate](https://codeclimate.com/github/howtohireme/give-me-poc) reporter,
that can collect code coverage metrics and publish them on the project page at Code Climate website.

### Seeds test

The goal of this job is to ensure that any changes introduced by the developer do not break seeds.
We want to have seeds up to date and workable, to provide new developers ability to set up the project at any moment.
Most of the requirements are the same for this job, as for unit tests.
We need `PostgreSQL`, `ruby` and gems installed, to be able to run `rake db:seeds` rake task.
Also, we manually import the DB schema into the database to be able to load seeds into the empty database.

### Migrations test

From our experience, the riskiest part of production deployment is the migration of data.
Quite often developers do not take into account the data from the real production database.
It can lead to the problems when we deploy those "naive" migrations on production, most often the migrations fail during deployment.
In other cases, we can get a broken app even after deployment.
To minimize risks we can, at least, check that proposed migrations run successfully on the production database.
We use production dump for that. So this job assumes, that you already have production dump somewhere.
The methods of performing and importing of the dump are described at [sepatate document](https://github.com/howtohireme/give-me-poc/blob/master/docs/db_dumps.md).
This job is quite similar to the `seeds test`, but requires some additional preparation, like installing the proper version of `pg_restore` utility.

### Docker images build

All previous jobs are executed in parallel, but docker image job has his stage.
The reason for that is that we don't want to push broken images to the registry.
On the other hand, this job can also be moved to the `tests` stage, to make the build faster, but in this case, we'll not have guaranteed that only working code is present in our docker images.

The result of `build` stage is a docker image, which is pushed to [public registry](https://hub.docker.com/u/howtohireme/).
This docker hub registry acts as an intermediate place for our images before they get shipped to production.

#### Master branch build

Whenever we build an image for `master` branch of the project, we tag it with `latest` label.
This image is used within subsequent `features` and `deploy` stages.

#### PR branch build

When we run tests for the feature branch, then we tag the resulting image with `branch_name` tag.
Keep in mind, that branch name should not contain `/` character, because it breaks the process of pulling the image at future steps.

### Features

Features are high-level acceptance tests written on human-readable `cucumber` language.
Those tests check that all business-critical processes work as expected in our application.
Features job assumes that we have either `latest` or `branch_name` images at our docker hub registry.

The script for this job is located at [bin/features](https://github.com/howtohireme/give-me-poc/blob/master/bin/travis-features).

As the first step of this build, we check out the [features repository](https://github.com/howtohireme/give-me-poc-features).
The next login depends on the current branch, that is used in this job.

#### Master branch

When we are testing the `master` branch, then the process is as simple as possible.
We pull the application image from docker hub with `latest` tag and rename it to be consistent with our Heroku application docker image name.

#### PR branch

In case we test PR branch we have several different flows.

* If features repo has a branch, with the same name as our current testing branch, then we change the branch in the features repository, to be able to use
the `docker-compose.yml` file from this branch.
It can be useful when we added some changes in this file too, besides regular tests changes.
After that, we use the image for features, tagged with the same name as our current branch.

* If features repo does not contain a branch with an appropriate name, then we test our current application image against the master image of features.
Usually, it happens when changes in the application do not break anything in features, for example during some refactoring.

Finally, when we have detected the required images for testing, we run `bin/run` script in features repo.
In launches the `docker compose`, that starts `mailhog`, `application`, `features`, `postgres`, `redis` containers, that simulate real application in production.

The main difference between features and real production environment is that application does not deal with the real mail server, GitHub, and slack accounts.
We use private environments for testing purposes, to prevent affecting the tools used in production.

NOTICE: At the moment we also have an initiative, that will replace usage of real Github and Slack APIs in favor of their stubbed implementation.


### Deploy

When the features and all previous stages completed successfully, we can deploy the prepared docker image to Heroku docker registry.
We prefer containerized deployment over the regular Heroku `git push`, because we can run multiple processes within a single docker container.

To do that we pull an image with `latest` tag from docker hub and rename it to follow Heroku image names convention.
After that, we login into Heroku registry, push the image.

Recent changes in Heroku containers infrastructure also require to install Heroku toolchain and explicitly mark the latest image as released.
Only after that, the new image is spawned at the Heroku.

### Backup

Besides `pr` and `push` events Travis allows to trigger build by schedule. This type of job is known as `cron`.
We run the `backup` job in this event every day.

The backup procedure is quite simple.
We pull the backup file from Heroku and push it to Amazon S3. We install `awscli` toolkit on each backup job.

Also, we keep track of the last 7 backups, and the latest one is also named as `latest`.
Each time when we create a backup and see, that there are more than 7 files on S3, we remove the oldest one, to prevent blowing up the S3 space.
