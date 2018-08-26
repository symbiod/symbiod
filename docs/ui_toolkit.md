# UI toolkit

## Based class links button

To display the status button with the ability to change it, the base class cell `Web:: Dashboard::BaseLinkStatusButton` is used, in which the method `link_to_status` is defined, which takes the parameters:

* `name:` takes the value of the link name, part i18n expression;
* `url:` takes the value of the link url;
* `color:` takes the value of the color bootstrap button;
* `confirm:` takes the value of the confirm message, part i18n expression.

In the child class, it is necessary to define the `url_status` method for the `url` variable. You can also redefine variables for some non-standard situations.

### Examples

#### Standart
`skill_status_button.rb`:

```
# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class SkillStatusButton < BaseLinkStatusButton
      private

      def url_status
        model.active? ? deactivate_dashboard_skill_url(model) : activate_dashboard_skill_url(model)
      end
    end
  end
end
```
`skill_status_button/show.haml`:
```
= link_to_status
```
#### Non-standart
`voting_panel.rb`:
```
# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rendring voting panel
    class VotingPanel < BaseLinkStatusButton
      def render_vote_action(vote)
        if ::Dashboard::VotePolicy.new(current_user, model).up?
          link_to_status name: vote,
                         url: url_status(vote),
                         color: color_status(vote),
                         confirm: confirm_status(vote)
        else
          vote
        end
      end

      private

      def url_status(vote)
        public_send("#{vote}_dashboard_idea_vote_url", model, id: model.id)
      end

      def color_status(vote)
        COLOR_STATUS[vote.to_sym]
      end

      def confirm_status(vote)
        CONFIRM_STATUS[vote.to_sym]
      end
    end
  end
end
```
`voting_panel/show.haml`:
```
= model.votes.up.count
= render_vote_action('up')
|
= render_vote_action('down')
= model.votes.down.count
```
