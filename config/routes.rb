# frozen_string_literal: true

require 'sidekiq/web'
require './lib/sidekiq_constraint'

Rails.application.routes.draw do
  scope module: :web do
    scope as: :bootcamp, module: :bootcamp, constraints: { subdomain: 'bootcamp' } do
      resource :user_sessions, only: :create

      namespace :wizard do
        resources :screenings, only: %i[index update]
        resource :profile, only: %i[edit update]
      end

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
      resources :test_task_assignments, only: %i[index show] do
        member do
          put :activate
          put :reject
        end
      end
      resources :users, only: %i[index show] do
        member do
          put :activate
          put :deactivate
          put :remove_role
          put :add_role
        end
      end
      resources :test_tasks, only: %i[index edit update]
      root to: 'home#index'
    end

    mount Sidekiq::Web => '/sidekiq', constraints: SidekiqConstraint.new
    root to: 'home#index', as: :root_landing, constraints: { subdomain: 'www' }
  end

  get '/ping', to: 'ping#index'
  root to: 'ping#redirect'
end
