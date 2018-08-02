# frozen_string_literal: true

require 'sidekiq/web'
require './lib/sidekiq_constraint'

Rails.application.routes.draw do
  scope module: :web do
    scope as: :bootcamp, module: :bootcamp, constraints: { subdomain: 'bootcamp' } do
      namespace :wizard do
        resources :screenings, only: %i[index update]
        resource :profile, only: %i[edit update]
        resource :accept_policy, only: %i[edit update]
      end

      post 'oauth/callback', to: 'oauths#callback'
      get 'oauth/callback', to: 'oauths#callback'
      get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

      root to: 'home#index'
    end

    scope as: :idea, module: :idea, constraints: { subdomain: 'idea' } do
      resource :registrations, only: %i[new create]
      resource :sessions, only: %i[new create]
      resources :proposals, only: %i[index create]
      root to: 'home#index'
    end

    scope as: :dashboard, module: :dashboard, constraints: { subdomain: 'dashboard' } do
      resources :test_task_assignments, only: %i[index show] do
        member do
          put :activate
          put :reject
        end
      end
      resources :users, only: %i[index show edit update] do
        member do
          put :activate
          put :deactivate
          put :remove_role
          put :add_role
        end
      end
      resources :skills, except: %i[show destroy] do
        member do
          put :activate
          put :deactivate
        end
      end
      resources :ideas, except: :destroy do
        member do
          put :voting
          put :activate
          put :deactivate
          put :reject
        end
        resources :votes, only: :index do
          member do
            put :up
            put :down
          end
        end
      end
      resources :test_tasks, except: :destroy do
        member do
          put :activate
          put :deactivate
        end
      end
      resource :profile, only: %i[show edit update]
      root to: 'home#index'
    end

    mount Sidekiq::Web => '/sidekiq', constraints: SidekiqConstraint.new

    delete '/logout', to: 'sign_outs#destroy', as: :logout
    root to: 'home#index', as: :root_landing, constraints: { subdomain: 'www' }
  end

  get '/ping', to: 'ping#index'
  match '/404' => 'errors#error404', via: %i(get post patch delete)
  root to: 'ping#redirect'
end
