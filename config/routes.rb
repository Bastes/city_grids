CityGrids::Application.routes.draw do
  root to: 'cities#index'

  get :about, to: 'about#index'

  resources :cities, only: [:show, :new, :create, :activate] do
    get :activate, on: :member
    resources :tournaments, only: [:new, :create]
  end

  resources :tournaments, only: [:show, :edit, :update, :destroy, :activate] do
    get :activate, on: :member
    resources :tickets, only: [:new, :create]
  end

  resources :tickets, only: [:activate, :forfeit] do
    get :activate, on: :member
    get :forfeit,  on: :member
  end
end
