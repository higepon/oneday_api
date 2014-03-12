class ApplicationController < ActionController::Base
  protect_from_forgery
  acts_as_token_authentication_handler_for User
end
