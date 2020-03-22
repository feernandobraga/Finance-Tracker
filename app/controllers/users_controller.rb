class UsersController < ApplicationController


  def my_portfolio

    # devise provies a helper method called current_user, that returns the current user logged in
    # by calling .strocks from a user, we get a list of stocks that are associated to that user
    @tracked_stocks = current_user.stocks

  end

end
