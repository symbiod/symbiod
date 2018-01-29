Rails.application.routes.draw do
  scope module: :web do
    scope module: :bootcamp, constraints: { subdomain: 'bootcamp' } do
      root to: 'home#index'
    end

    scope module: :idea, constraints: { subdomain: 'idea' } do
      root to: 'home#index'
    end

    scope module: :dashboard, constraints: { subdomain: 'dashboard' } do
      root to: 'home#index'
    end
  end
end
