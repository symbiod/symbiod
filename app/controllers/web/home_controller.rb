# frozen_string_literal: true

module Web
  # Controller landing page
  class HomeController < ApplicationController
    def index
      @developers_size = User.with_role(:developer).count
      @mentors_size = User.with_role(:mentor).count
      @projects_size = Project.all.count
    end
  end
end
