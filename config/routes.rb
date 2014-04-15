CityGrids::Application.routes.draw do
  root to: 'cities#index'

  resources :cities, only: [:show, :new, :create] do
    resources :tournaments, only: [:new, :create]
  end

  resources :tournaments, only: [:show, :activate] do
    get :activate, on: :member
  end
end
