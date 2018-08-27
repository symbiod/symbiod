# frozen_string_literal: true

# All application cells should inherit from this class.
# It provides available helpers from simple_form and other useful staff.
class BaseCell < Cell::ViewModel
  # include ActionView::Helpers::UrlHelper
  # include ActionView::Helpers::CaptureHelper
  # include ActionView::Helpers::FormHelper
  # include ActionView::RecordIdentifier
  # include ApplicationHelper
  # include AbstractController::Helpers
  include SimpleForm::ActionViewExtensions::FormHelper
  include MarkdownHelper
  include Pundit
  include ActionView::Helpers::TranslationHelper

  def current_user
    controller.current_user
  end

  LINK_STATUS = {
    pending: 'disabled',
    invited: 'disabled',
    joined: 'disabled',
    left: 'disabled',
    completed: 'disabled',
    profile_completed: 'disabled',
    rejected: 'disabled',
    policy_accepted: 'disabled',
    screening_completed: 'disabled'
  }.freeze

  COLOR_STATUS = {
    pending: 'danger',
    profile_completed: 'danger',
    rejected: 'danger',
    policy_accepted: 'danger',
    screening_completed: 'warning',
    active: 'success',
    disabled: 'danger',
    invited: 'warning',
    joined: 'success',
    left: 'danger',
    voting: 'warning',
    completed: 'success',
    up: 'success',
    down: 'danger',
    up_arrow: 'green',
    down_arrow: 'red'
  }.freeze

  CONFIRM_STATUS = {
    active: 'disable',
    pending: 'voting',
    disabled: 'activate',
    up: 'up',
    down: 'down',
    voting: 'activate'
  }.freeze
end
