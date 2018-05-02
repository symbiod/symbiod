# frozen_string_literal: true

# Base controller of application
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery prepend: true, with: :exception
end
