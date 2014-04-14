# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if ENV['basic_auth_username'] && ENV['basic_auth_password']
  use Rack::Auth::Basic, "" do |username, password|
    [username, password] == [ENV['basic_auth_username'], ENV['basic_auth_password']]
  end
end

run Rails.application
