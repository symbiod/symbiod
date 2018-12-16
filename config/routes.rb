# frozen_string_literal: true

require 'sidekiq/web'
require './lib/sidekiq_constraint'

Rails.application.routes.draw do
  scope module: :web do
    namespace :bootcamp do
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

    namespace :idea do
      resource :sessions, only: %i[new create]

      namespace :wizard do
        resource :registrations, only: %i[new create]
        resource :policy, only: %i[edit update]
        resources :proposals, only: %i[index create]
      end
      root to: 'home#index'
    end

    namespace :dashboard do
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
        resources :notes, except: %i[index]
      end
      resources :role_activation, only: :update
      resources :force_role_activation, only: :update
      resources :role_deactivation, only: :update
      resources :survey_responses, only: %i[index show new create]
      resources :feedback_questions, except: %i[show]
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
      resources :projects, only: %i[index show edit update]
      resource :profile, only: %i[show edit update]
      root to: 'home#index'
    end

    resource :locales, only: [] do
      collection do
        get :toggle
      end
    end

    mount Sidekiq::Web => '/sidekiq', constraints: SidekiqConstraint.new

    delete '/logout', to: 'sign_outs#destroy', as: :logout
    root to: 'home#index', as: :root_landing
  end

  get '/ping', to: 'ping#index'
  root to: 'ping#redirect'
end
