class UserStocksController < ApplicationController

  def create
    # this method is called when the user presses the "Add to portfolio" button from the _result.html.erb
    # the method receives the current user logged in, and the ticker that the user searched, i.e AAPL.
    # Then, it checks if the tickers is already in the database:
    #  * If the tickers is already in the database, it grabs the ticker object and add to the user_stocks table
    #  * If the ticker is NOT in the database, then it calls the API for the information and saves it on the DB

    # calls the method check_db from the Stock model to see if the ticker is already in the database
    stock = Stock.check_db(params[:ticker])

    # if the method above can't find the ticker, then it hits the API
    if stock.blank?

      # new_lookup is a method from the Stock model that hits the API for a given ticker
      # and returns a stock object (with ticker, name and price as per Stock model) that is saved
      # into the stock table in the DB
      stock = Stock.new_lookup(params[:ticker])
      stock.save

    end # end if stock.blank?

    # once the stock object is retrieve (either form the DB or the API), I can save it to the DB (user_stocks table)
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path

  end # end create

  def destroy
    # this method will be called from the remove button in the stocks/_list.html.erb and the buttons passes in
    # the stock object. So I'll store the stock object and then I'll:
    #   * use the current_user method (from DEVISE helper) to get the user
    #   * use the stock ID that I received from the params
    #   * use UserStock.where to get the object from user_stock table where user = current_user and stock_id = stock.id
    #   * then I can simply destroy it.
    # The method .first is used so I can grab the object instead of the association from the database

    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was removed"
    redirect_to my_portfolio_path

  end # end destroy


end # end class
