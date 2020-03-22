class StocksController < ApplicationController

  def search

    # first I check if the user actually entered a stock symbo
    if params[:stock].present?

      # this will run the method new_lookup from the Stock model
      # and save the value into the variable @stock
      @stock = Stock.new_lookup(params[:stock])

      # if the API call DOESN'T return nil, then it means that the user entered
      # a valid symbol. For that case, we render the view with the stock information,
      # otherwise, we display an alert and redirect to my_portfolio
      if @stock

        ### the line below got deprecated by the new JS response
        ### render 'users/my_portfolio'


        # respond_to will handle the response to the Ajax request that comes from the form in
        # my_portfolio.html.erb.
        respond_to do |format|
          format.js {render partial: 'users/result'} # This will expect a JS file (_result.JS.erb)
        end

      else

        ### the lines below got deprecated by the new JS response
        ### flash[:alert] = "#{params[:stock]} is not a valid stock symbol!"
        ### redirect_to my_portfolio_path

        respond_to do |format|
          # I've changed from flash to flash.now so it disappears when I hit search again
          flash.now[:alert] = "#{params[:stock]} is not a valid stock symbol!"
          format.js {render partial: 'users/result'} # This will expect a JS file (_result.JS.erb)
        end

      end # end if @stock

    else

      ### the lines below got deprecated by the new JS response
      ### flash[:alert] = "Please enter a Symbol to Search"
      ### redirect_to my_portfolio_path

      respond_to do |format|
        # I've changed from flash to flash.now so it disappears when I hit search again
        flash.now[:alert] = "#{params[:stock]} Please enter a Symbol to Search!"
        format.js {render partial: 'users/result'} # This will expect a JS file (_result.JS.erb)
      end

    end # end if params[:stock].present?

  end # end search

end
