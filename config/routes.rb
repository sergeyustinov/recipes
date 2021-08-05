Rails.application.routes.draw do
  devise_for :users

  resources :recipes, except: %i[show] do
    collection do
      get :my
      get :recent, format: :json
    end
  end

  root to: 'recipes#index'
end
