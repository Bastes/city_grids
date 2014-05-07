module ApplicationHelper
  def current_city value = nil
    if value
      @current_city = value
    else
      @current_city
    end
  end

  def bb tag_name, arg = nil, &block
    %Q([#{tag_name}#{if arg then "=#{arg}" end}]#{capture &block}[/#{tag_name}])
  end
end
