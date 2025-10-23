class ApplicationController < ActionController::API
  include ExceptionHandler
  include Authenticable
end
