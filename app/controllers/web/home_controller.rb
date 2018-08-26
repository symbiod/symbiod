# frozen_string_literal: true

module Web
  # Controller landing page
  class HomeController < ApplicationController
    def index
      @members_size = User.with_role(:member).count
      @mentors_size = User.with_role(:mentor).count
      @projects_size = Project.all.count
    end
  end
end
