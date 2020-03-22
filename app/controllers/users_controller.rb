class UsersController < ApplicationController


  def my_portfolio

    # devise provies a helper method called current_user, that returns the current user logged in
    # by calling .strocks from a user, we get a list of stocks that are associated to that user
    @tracked_stocks = current_user.stocks

  end # end my_portfolio

  def my_friends
    # this method simply gets all friends from the logged user and passes it through to my_friends.html.erb view
    # the method current_user is from DEVISE and brings back the current user

    @friends = current_user.friends

  end # end my_frieds

  def search
    # this is the methods that wil handle the search functionality from my_friends.html.erb
    # The steps are:
    #   * Check if the user actually entered something in the search field, if not, display a flash notice
    #   * attribute that to an instance variable called @friend
    #   * if the friend exists, then display it, if not, inform user not found

    if params[:friend].present?

      @friend = params[:friend]

      if @friend

        respond_to do |format|
          format.js { render partial: 'users/friend_result'}
        end

      else

        respond_to do |format|
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: 'users/friend_result'}
        end

      end # end @friend

    else

      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.js { render partial: 'users/friend_result'}
      end

    end # end params[:friend].present?


  end # end search


end # end class
