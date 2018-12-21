# Architecture

Overall the application is a single monolith Rails, which acts as a Web application with a set of background tasks. The primary goal of the application is to provide flows for business logic and automate its communication with 3rd-party services.

## Processes

Besides the regular Rails app, we have a sidekiq daemon, which executes queued in Redis jobs.

The scheduler process initiates all events, which should be triggered by the schedule. To sum up, we have 3 processes that run together to make the system live.

Examine the [Procfile](https://github.com/symbiod/symbiod/blob/master/Procfile.production) to see the list of processes.

## Namespacing

We want our codebase to reflect the business side of the project, to achieve that we need a proper naming of all entities in the system.
This requirement applies to all classes in the system, including Cells, Operations, Forms, Controllers, Models.

For example, take a look at the [operations directory](https://github.com/symbiod/symbiod/tree/master/app/operations/ops). The root namespace contains the names of entities, which might act as the subjects of different operations. Some deeper nesting may be required as well. `Member` namespace has [additional nesting](https://github.com/symbiod/symbiod/tree/master/app/operations/ops/member), that represents other entities such as `Onboarding` or `Screening`.

There are no strict guidelines that describe how should we choose if a new operation deserves a separate namespace, most often we use common sense and discuss possible naming with team members.

Before creating the class think about:
* What is the subject of the class? Since all the classes do only one thing, each of them most probably has a subject.
* Does this subject have a parent? Remember about example `Member::Onboarding`.
* Does this class work only with a single kind of subject? If it works with multiple classes, then it should be located somewhere higher in the namespaces tree.

## Operations

All business logic flows are isolated in the `app/operations` directory, which contains classes, based on `Trailblazer::Operation`.
Each business action is represented by a separate `Operation` class and can be reused wherever is it required.

The main idea of operations is to provide an abstraction from the HTTP layer and perform any business logic.

To clarify that we have a set of rules, that apply to the operations:
* It should have specific business value
* It should not deal with controller parameters directly. Every parameter should have business meaning.
* It can be reused in different contexts.
* It should not deal with low-level classes, like API clients.
* It should not interact with ENV variables directly.

## Integrations

At the moment we have integrations with:
* Github
* Slack

All integration-related logic is located at service classes of an `app/services` directory. The goal of these services is to adopt a unified adapter interface to the context of our application.

Very important is that we do not use gems or API clients from 3rd-party libraries anywhere in the application code directly. We should always use our custom services, that wrap API clients. That makes testing more comfortable, and it becomes possible to switch to other libraries without rewriting any application code.

## Queries

The main idea is to isolate complicated SQL queries in separate classes, located at `app/queries`. There are no strict rules when we should extract query objects, use your common sense. 

For example, when testing of the operation involves the creation of a complex dataset, then it makes sense to extract that object.

This approach helps to achieve more comfortable testing when we can mock the result of the query object and test it separately.

## Jobs

We use `ActiveJob` with the sidekiq adapter for handling the background jobs.
There are several best practices, which should be used when working with jobs:

* Do not pass ActiveRecord objects as an argument of the job. Prefer passing object.id instead.
* Do not put any complicated business logic in jobs. The job should receive a list of parameters and load required objects from the database. After that pass those objects as arguments to the specific operation.

## Policies

Policies define which roles may have access to different parts of the system. They are located at `app/policies`.

The primary guideline for working with policies is to prevent explicit checking the roles somewhere in the code. So, whenever we want to ensure, that user can perform some action in the system, we should call appropriate policy, which returns a pure boolean value.

This approach allows us to change restrictions in a centralized manner, without changing any specific application code.

## Forms

Forms allow to create custom validations for user input, that can depend on the context. For example, the `Role` model might have different sets of validation depending on the current user, or the specific area of the application.

For such cases, we define in models only those validations, which are applicable in all possible contexts, and guarantee data consistency. All other context-specific validations are implemented in forms.

## Cells

We use cells for complicated pieces of view logic, that can be reused on different pages. The primary indicator that cell extraction makes sense is the complex Ruby logic inside view/helper. Anything that requires more that one pure conditional expression or iterator look should be extracted into a separate cell.

## Roles system

At the moment we have the following design of users and roles in the system:

`User` model represents a specific person, that uses the system. It keeps only the data, that is common to _all_ user roles, like email, name or password hash.

This person can have multiple roles, which define possible workflows and keep role-specific data.
User itself does not have any `state` column, so if we want to find an `active` user, then we search for a user, that has _at least_ one `active` role.

`Role` model represents the state of the specific application, and keep all the data required for this role and corresponding relations.
For example, member and mentor roles require `test_task_assignments` relation, and it should be located in those roles models.

Each role is represented by a separate class located at `app/roles/*`.

At the moment we have the following roles:

* `Roles::Member`
* `Roles::Mentor`
* `Roles::Author`
* `Roles::Staff`

For convenience we have `Rolable` module, that is included in the `User` model.
It works as a bridge for `Roles::RolesManager`, that handles all roles management logic.
