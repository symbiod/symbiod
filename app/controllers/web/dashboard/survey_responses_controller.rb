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
        @survey_responses = Developer::Onboarding::SurveyResponse.order(id: :desc).page params[:page]
      end

      def show; end

      def new
        @survey_response = Developer::Onboarding::SurveyResponse.new
      end

      def create
        @survey_response = Developer::Onboarding::SurveyResponse.new(survey_response_params)
        if @survey_response.save
          Staff::SurveyResponseCompletedMailer.notify(@survey_response.user.id).deliver_later
          redirect_to dashboard_root_url,
                      flash: { success: t('dashboard.survey_responses.notices.success') }
        else
          render 'new'
        end
      end

      private

      def survey_response_find
        @survey_response = Developer::Onboarding::SurveyResponse.find(params[:id])
      end

      def survey_response_params
        params
          .permit(developer_onboarding_survey_response: {})
          .require(:developer_onboarding_survey_response)
      end

      def questions_find
        @questions = Developer::Onboarding::FeedbackQuestion.order(id: :asc)
      end
    end
  end
end
