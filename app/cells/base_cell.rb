class BaseCell < Cell::ViewModel
  #include ActionView::Helpers::UrlHelper
  #include ActionView::Helpers::CaptureHelper
  #include ActionView::Helpers::FormHelper
  #include ActionView::RecordIdentifier
  #include ApplicationHelper
  #include AbstractController::Helpers
  include SimpleForm::ActionViewExtensions::FormHelper

  def current_user
    controller.current_user
  end
end
