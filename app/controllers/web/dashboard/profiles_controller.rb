# frozen_string_literal: true

module Web
  module Dashboard
    # Allows to view and edit the profile of current user.
    # Can be used after successful signup process.
    class ProfilesController < BaseController
      before_action :profile

      def show; end

      def edit; end

      def update
        if profile.update(profile_params)
          redirect_to dashboard_profile_url, success: t('dashboard.profile.update.flash.success')
        else
          render :edit
        end
      end

      private

      def profile
        @profile ||= current_user
      end

      def profile_params
        params.require(:user)
              .permit(:first_name, :last_name, :location, :timezone, :cv_url)
      end
    end
  end
end
