class Stock < ApplicationRecord

  # this is a class method (I had to use self. to make it
  # available even without an instance of this model)
  def self.new_lookup(ticker_symbol)



    # this is what connects us to the API
    # The value for publish token is an API key that we hid inside the credentials.yml.enc
    # This file is encypted and the only way of acessing it is by using the master.key
    client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
        endpoint: 'https://sandbox.iexapis.com/v1')



    # the method .price is from the API documentation and since ruby doesn't need RETURN,
    # this will return the stock price based on the ticker_symbol given
    #
    # client.price(ticker_symbol) -- this has been commented out because we will now
    # return an object with more information intead of just the price
    #


    # here I'm basically creating a new object of type Stock with the following attributes:
    # ticker - I'll pass whatever this method received through the ticker_symbol
    # name - this is from the gem documentation:- client.company(ticker_symbol).company_name
    # price - also from the documentation:- client.price(ticker_symbol)
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name,
          last_price: client.price(ticker_symbol)
      )

    rescue => exception # this is to handle exceptions in case the user enters an invalid symbol.

      return nil
      # in case of an exception, we just return nil and then we check that in the stocks_controller#search

    end

  end

end
