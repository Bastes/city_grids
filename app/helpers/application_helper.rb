module ApplicationHelper
  def current_city value = nil
    if value
      @current_city = value
    else
      @current_city
    end
  end
end
