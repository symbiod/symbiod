# frozen_string_literal: true

module Web
  module Dashboard
    # This controlle manage questions to feedbacks
    class FeedbackQuestionsController < BaseController
      before_action :question_find, only: %i[edit update destroy]
      before_action do
        authorize_role(%i[dashboard feedback_question])
      end

      def index
        @questions = Developer::Onboarding::FeedbackQuestion.order(id: :asc)
      end

      def new
        @question = Developer::Onboarding::FeedbackQuestion.new
      end

      def create
        @question = Developer::Onboarding::FeedbackQuestion.new(question_params)
        if @question.save
          redirect_to dashboard_feedback_questions_url,
                      flash: { success: t('dashboard.feedback_questions.notices.success.create') }
        else
          flash.now[:danger] = t('dashboard.feedback_questions.notices.danger.create')
          render :new
        end
      end

      def edit; end

      def update
        if @question.update(question_params)
          redirect_to dashboard_feedback_questions_url,
                      flash: { success: t('dashboard.feedback_questions.notices.success.update') }
        else
          flash.now[:danger] = t('dashboard.feedback_questions.notices.danger.update')
          render :edit
        end
      end

      def destroy
        @question.destroy
        redirect_to dashboard_feedback_questions_url,
                    flash: { success: t('dashboard.feedback_questions.notices.success.destroy') }
      end

      private

      def question_find
        @question = Developer::Onboarding::FeedbackQuestion.find(params[:id])
      end

      def question_params
        params
          .require(:developer_onboarding_feedback_question)
          .permit(:description, :key_name)
      end
    end
  end
end
