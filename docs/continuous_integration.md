# Continuous Integration

Our working process relies on our CI in many places. We do the following things with CI:

* Run unit tests
* Validate project seeds
* Validate introduced migrations against current DB from production
* Build docker images
* Run cucumber tests
* Deploy new versions
* Perform DB backups

For each step we have a script, defined at [bin](https://github.com/howtohireme/give-me-poc/tree/master/bin) directory of the project.

## Pipeline

All those things are organized as a pipeline, its example is available on the [following screenshot](https://monosnap.com/file/0gPd5iAHuewAi36xExMCFGHs6nZPj6).
The pipeline is devided into several stages, all stages are executed sequentially. Each stage may include several jobs, that are executed in parallel.

In the example from the link you can see, that the `tests` stage includes 3 jobs, that can be run in parallel to speedup build time.

Our CI starts the next stage only if all jobs from previous stages finished successfully.
This will prevent us from using redundant resources if the code has some obvious problem that was found on `tests` stage.

## Travis

We use [Travis](https://travis-ci.org/howtohireme/give-me-poc) as our CI service.
All required configuration is defined at [.travis.yml](https://github.com/howtohireme/give-me-poc/blob/master/.travis.yml) file at the repository.
It allows us to install additional software, define the order of stages and jobs within the stage.
Also we can define conditional stages, that will be executed on specific conditions.

## Jobs

### Unit tests

Unit tests job is the most important for daily developer's work.
It is executed almost on every event, and runs first to provide a fast feedback to developer.
We run it on `pr` and `push` events and skip the `cron` event.
So each time you push some commits to the remote repository it triggers tests stage.
For this job we require `postgresql` and `redis` to be installed, also we install [code climate](https://codeclimate.com/github/howtohireme/give-me-poc) reporter,
that is able to collect code coverage metrics and publish them on the project page at Code Climate website.

### Seeds test

The goal of this job is to ensure that any changes intoroduced by developer do not break seeds.
We want to have seeds up to date and working, to prodive new developers ability to setup the project at any moment.
Most of requirements are the same for this job, as for unit tests.
We need `postgresql`, `ruby` and gems installed, to be able to run `rake db:seeds` rake task.
In addition we manually import the DB schema into the database to be able to load seeds into the empty database.

### Migrations test

From our experience, the most risky part of production deployment is the migration of data.
Quite often developers do not take into account the data from real production database.
This can lead to the problems, when we deploy those "naive" migrations on production, most often the migrations just fail during deployment.
In other cases we can get a broken app even after deployment.
To minimize risks we can, at least, check that proposed migrations will run successfully on the production database.
We use production dump for that. So this job assumes, that you already have production dump somewhere.
The methods of performing and importing of dump are described at [sepatate document](https://github.com/howtohireme/give-me-poc/blob/master/docs/db_dumps.md).
This job is quite similar to the `seeds test`, but requires some additional preparation, like installing the proper version of `pg_restore` utility.

### Docker images build

All previous jobs were executed in parallel, but docker image job has his own stage.
The reason for that is that we don't want to push broken images to the registry.
On the other hand, this job can be also moved to the `tests` stage, to make the build faster, but in this case we'll not have guarantee that only working code is present in our docker images.

The result of `build` stage is a docker images, that are pushed to [public registry](https://hub.docker.com/u/howtohireme/).
This dockerhub registry acts as an intermediate place for our images, before they get shipped to production.

#### Master branch build

Every time when we build an image for `master` branch of the project we tag it with `latest` label.
This image will be used within subsequent `features` and `deploy` stages.

#### PR branch build

When we run tests for feature branch, then we tag the result image with `branch_name` tag.
Keep in mind, that branch name should not contain `/` charactor, because it will break the process of pulling the image.

### Features

Features are high-level acceptance tests, that are written on human-readable `cucumber` language.
Those tests check that all business critical processes work as expected in our application.
Features job assumes, that we have either `latest` or `branch_name` images at our dockerhub registry.

The script for this job is located at [bin/features](https://github.com/howtohireme/give-me-poc/blob/master/bin/travis-features).

As the first step of this build we check out the [features repository](https://github.com/howtohireme/give-me-poc-features).
The next login depends on the current branch, that is used in this job.

#### Master branch

When we are testing the `master` branch, then the process is simple as possible.
We pull the application image from dockerhub with `latest` tag, and rename it to be consistent with our Heroku application docker image name.

#### PR branch

In case we test PR branch we have several different flows.

* If features repo has a branch, with the same name as our current testing branch, then we change the branch in the features repository, to be able to use
the `docker-compose.yml` file from this branch.
It can be useful when we added some changes in this file too, besides regular tests changes.
After that we use the image for features, tagged with the same name as our current branch.

* If features repo does not contain a branch with appropriate name, then we test our current application image against the master image of features.
Usually it happens when changes in application do not break anything in features, for example during some refactoring.

Finally, when we have detected the required images for testing, we run `bin/run` script in features repo.
In launches the `docker compose`, that starts `mailhog`, `application`, `features`, `postgres`, `redis` containers, that simulate real application in production.

The main difference between features and real production environment is that application does not deal with real mail server, github and slack accounts.
We use special environments for testing purposes, to prevent affecting the tools used in production.

NOTICE: At the moment we also have an initiative, that will replace usage of real Github and Slack APIs in favor of their stubbed implementation.


### Deploy

When the features and all previous stages completed successfully, we can deploy the prepared docker image to Heroku docker registry.
We prefer containeraized deployment over the regular heroku `git push`, because we can run multiple processes within a single docker container.

To do that we pull an image with `latest` tag from dockerhub and rename it to follow heroku image names convention.
After that we log in into heroku registry, push the image.

Recent changes in heroku containers infrastructure require also to install heroku toolchain and explicitly mark the latest image as released.
Only after that the new image in spawned at the heroku.

### 








