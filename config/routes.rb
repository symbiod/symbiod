# frozen_string_literal: true

require 'sidekiq/web'
require './lib/sidekiq_constraint'

Rails.application.routes.draw do
  scope module: :web do
    scope as: :bootcamp, module: :bootcamp, constraints: { subdomain: 'bootcamp' } do
      resource :registration, only: %i[new create]
      resource :user_sessions, only: :create
      get '/login', to: 'user_sessions#new', as: :login
      post '/logout', to: 'user_sessions#destroy', as: :logout
      post 'oauth/callback', to: 'oauths#callback'
      get 'oauth/callback', to: 'oauths#callback'
      get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
      root to: 'home#index'
    end

    scope as: :idea, module: :idea, constraints: { subdomain: 'idea' } do
      root to: 'home#index'
    end

    scope as: :dashboard, module: :dashboard, constraints: { subdomain: 'dashboard' } do
      root to: 'home#index'
    end

    mount Sidekiq::Web => '/sidekiq', constraints: SidekiqConstraint.new
    root to: 'home#index'
  end
end
