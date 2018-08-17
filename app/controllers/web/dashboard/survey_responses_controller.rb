# frozen_string_literal: true

module Web
  module Dashboard
    # This controller manage feedback users after onboarding
    class SurveyResponsesController < BaseController
      before_action :survey_response_find, only: :show
      before_action do
        authorize_role(%i[dashboard survey_response])
      end

      def index
        @survey_responses = Developer::Onboarding::SurveyResponse.all
      end

      def show; end

      def new
        @survey_response = Developer::Onboarding::SurveyResponse.new
      end

      def create
        result = Ops::Developer::Onboarding::SubmitSurveyResponse.call(params: survey_response_params)
        if result.success?
          redirect_to dashboard_root_url,
                      flash: { success: t('dashboard.survey_responses.notices.success') }
        else
          @survey_response = result['contract.default']
          render 'new'
        end
      end

      private

      def survey_response_find
        @survey_response = Developer::Onboarding::SurveyResponse.find(params[:id])
      end

      def survey_response_params
        params
          .require(:developer_onboarding_survey_response)
          .permit(:user_id, :question_1, :question_2)
      end
    end
  end
end
