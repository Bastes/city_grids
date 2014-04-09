class CitiesController < ApplicationController
  def index
    @cities = City.order(name: :asc)
  end
end
