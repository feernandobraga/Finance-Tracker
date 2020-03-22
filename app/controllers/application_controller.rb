class ApplicationController < ActionController::Base

  # this is from the devise gem and it's used so the user can't do anything before logging in.
  before_action :authenticate_user!

  # this is so we can permit other fields like first name and last name to be handled by devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # this method will allow extra params to be used by devise, like first and last name.
  # This came from Devise's documentationg
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
