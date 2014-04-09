class CitiesController < ApplicationController
  def index
    @cities = City.order(name: :asc).all
  end
end
