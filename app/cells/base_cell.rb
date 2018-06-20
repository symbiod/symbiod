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
end
