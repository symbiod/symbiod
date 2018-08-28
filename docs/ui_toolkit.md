# UI toolkit

## Based class links button

To display the status button with the ability to change it, the base class cell `Web::Dashboard::BaseStatusButton` is used, in which the method `link_to_status` is defined, which takes the parameters:

* `status:` takes the value of the name, as well as the color and status of the button's activity based on it;
* `url:` takes the value of the link url;
* `confirm:` takes the value of the confirm message, part i18n expression, if not specified, then the link is generated without confirm.

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
= link_to_status confirm: model.state
```
#### Non-standart
`voting_panel.rb`:
```
# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rendring voting panel
    class VotingPanel < BaseStatusButton
      def render_vote_action(vote)
        if ::Dashboard::VotePolicy.new(current_user, model).up?
          link_to_status status: vote, url: url_status(vote)
        else
          content_tag :i,
                      nil,
                      class: "fa fa-arrow-#{vote}",
                      style: "color: #{style_color(vote)}"
        end
      end

      private

      def url_status(vote)
        public_send("#{vote}_dashboard_idea_vote_url", model, id: model.id)
      end

      def style_color(vote)
        COLOR_STATUS["#{vote}_arrow".to_sym]
      end
    end
  end
end
```
`voting_panel/show.haml`:
```
- if ::Dashboard::VotePolicy.new(current_user, model).voting_panel?
  %tr
    %td
      %b= link_to t('dashboard.ideas.table.votes'), dashboard_idea_votes_url(model)
    %td
      = model.votes.up.count
      = render_vote_action('up')
      |
      = render_vote_action('down')
      = model.votes.down.count
```
