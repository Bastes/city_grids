class CitiesController < ApplicationController
  responders :flash

  def index
    @cities = City.activated.
      eager_load(:incoming_tournaments).
      group('cities.id, tournaments.id').
      order('COUNT(tournaments.id) > 0 DESC, cities.name asc, tournaments.begins_at asc').
      load
  end

  def show
    @city = City.includes(incoming_tournaments: :present_tickets).find params[:id]
  end

  def new
    @city = City.new
  end

  def create
    @city = City.find_by_name(params[:city][:name])
    if @city
      if @city.activated
        redirect_to @city
      else
        if @city.update_attributes email: params[:city][:email]
          flash[:notice] = I18n.t 'flash.cities.create.notice'
          CityMailer.activation(@city).deliver if @city.valid?
          redirect_to root_path
        else
          respond_with @city = City.create(permitted_params)
        end
      end
    else
      @city = City.create permitted_params
      CityMailer.activation(@city).deliver if @city.valid?
      respond_with @city, location: root_path
    end
  end

  def activate
    city = City.find params[:id]
    if city.admin == params[:a]
      city.update_attributes activated: true
      flash[:notice] = I18n.t 'flash.cities.activate.notice'
      redirect_to city
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def permitted_params
    params.require(:city).permit(:name, :email)
  end
end
