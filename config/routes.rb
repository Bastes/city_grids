CityGrids::Application.routes.draw do
  root to: 'cities#index'

  resources :cities, only: [:show] do
    resources :tournaments, only: [:new, :create]
  end
end
