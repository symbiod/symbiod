# frozen_string_literal: true

# render 404 page if status 'not found'
class ErrorsController < ApplicationController
  def error404
    render status: :not_found
  end
end
