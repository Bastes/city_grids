CityGrids::Application.routes.draw do
  root to: 'cities#index'

  resources :cities, only: [:show]
end
