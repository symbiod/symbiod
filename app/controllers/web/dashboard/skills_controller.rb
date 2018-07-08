# frozen_string_literal: true

module Web
  module Dashboard
    # This controller manage skills
    class SkillsController < BaseController
      before_action :skill_find, only: %i[edit update activate deactivate]
      before_action :authorize_role
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_root

      def index
        @skills = Skill.order(id: :desc)
      end

      def new
        @skill = Skill.new
      end

      def create
        @skill = Skill.new(skill_params)
        if @skill.save
          redirect_to dashboard_skills_url,
                      flash: { success: "#{t('dashboard.skills.create.success')}: #{@skill.title}" }
        else
          flash.now[:danger] = t('dashboard.skills.create.danger')
          render :new
        end
      end

      def edit; end

      def update
        if @skill.update(skill_params)
          redirect_to dashboard_skills_url,
                      flash: { success: "#{t('dashboard.skills.update.success')}: #{@skill.title}" }
        else
          flash.now[:danger] = t('dashboard.skills.update.danger')
          render :edit
        end
      end

      def activate
        @skill.activate!
        redirect_to dashboard_skills_url,
                    flash: { success: "#{t('dashboard.skills.notice.activate')}: #{@skill.title}" }
      end

      def deactivate
        @skill.disable!
        redirect_to dashboard_skills_url,
                    flash: { success: "#{t('dashboard.skills.notice.deactivate')}: #{@skill.title}" }
      end

      private

      def skill_params
        params.require(:skill).permit(:title)
      end

      def authorize_role
        authorize %i[dashboard skill], "#{action_name}?".to_sym
      end

      def skill_find
        @skill = Skill.find(params[:id])
      end
    end
  end
end
