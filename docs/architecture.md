# Architecture

## Roles system

At the moment we have the following design of users and roles in the system:

`User` model represents a specific person, that uses the system. It keeps only the data, that is common to _all_ user roles, like email, name or password hash.

This person is able to have multiple roles, that define possible workflows and keep role-specific data.
User itself does not have any `state` column, so if we want to find an `active` user, then we search for a user, that has _at least_ one `active` role

`Role` model represents the state of the specific application, and keep all the data required for this role and corresponding relations.
For example member and mentor roles require `test_task_assignments` relation, and it should be located in those roles models.

Each role is represented by a separate class located at `app/roles/*`.

At the moment we have the following roles:

* `Roles::Member`
* `Roles::Mentor`
* `Roles::Author`
* `Roles::Staff`

For convenience we have `Rolable` module, that is included in `User` model.
It works as a bridge for `Roles::RolesManager`, that handles all roles management logic.
