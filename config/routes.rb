Rails.application.routes.draw do
  scope module: :web do
    scope as: :bootcamp, module: :bootcamp, constraints: { subdomain: 'bootcamp' } do
      resource :registration, only: [:new, :create]
      root to: 'home#index'
    end

    scope as: :idea, module: :idea, constraints: { subdomain: 'idea' } do
      root to: 'home#index'
    end

    scope as: :dashboard, module: :dashboard, constraints: { subdomain: 'dashboard' } do
      root to: 'home#index'
    end

    root to: 'home#index'
  end
end
