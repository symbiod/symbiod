# frozen_string_literal: true

# This endpoint is used to check if the app is alive
class PingController < ApplicationController
  def index
    head :ok, content_type: 'text/html'
  end
end
