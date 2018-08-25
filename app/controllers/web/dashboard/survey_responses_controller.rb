# frozen_string_literal: true

module Web
  module Dashboard
    # This controller manage feedback users after onboarding
    class SurveyResponsesController < BaseController
      before_action :survey_response_find, only: :show
      before_action :questions_find, only: %i[new create]
      before_action do
        authorize_role(%i[dashboard survey_response])
      end

      def index
        @survey_responses = Member::Onboarding::SurveyResponse.order(id: :desc).page params[:page]
      end

      def show; end

      def new
        @survey_response = Member::Onboarding::SurveyResponse.new
      end

      def create
        result = Ops::Member::Onboarding::CreateSurveyResponse.call(
          user: current_user, params: survey_response_params
        )
        if result.success?
          redirect_to dashboard_root_url,
                      flash: { success: t('dashboard.survey_responses.notices.success') }
        else
          @survey_response = result[:model]
          render 'new'
        end
      end

      private

      def survey_response_find
        @survey_response = Member::Onboarding::SurveyResponse.find(params[:id])
      end

      def survey_response_params
        params
          .permit(member_onboarding_survey_response: {})
          .require(:member_onboarding_survey_response)
          .merge(role_id: current_user.role(:member).id)
      end

      def questions_find
        @questions = Member::Onboarding::FeedbackQuestion.order(id: :asc)
      end
    end
  end
end
