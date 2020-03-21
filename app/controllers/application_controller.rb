class ApplicationController < ActionController::Base

  # this is from the devise gem and it's used so the user can't do anything before logging in.
  before_action :authenticate_user!

end
