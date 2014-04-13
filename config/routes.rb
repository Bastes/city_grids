CityGrids::Application.routes.draw do
  root to: 'cities#index'

  resources :cities, only: [:show] do
    resources :tournaments, only: [:new, :create]
  end

  resources :tournaments, only: [:activate] do
    get :activate, on: :member
  end
end
