# frozen_string_literal: true

module Web
  # Controller landing page
  class HomeController < ApplicationController
    def index
      @developers_size = User.with_role(:developer).size
      @mentors_size = User.with_role(:mentor).size
      @projects_size = Project.all.size
    end
  end
end
