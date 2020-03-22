class Stock < ApplicationRecord

  # the lines below create the many to many association.
  # It's importante to include "through" as it allows for functionalities like
  # stock.users and also user.stocks
  has_many :user_stocks
  has_many :users, through: :user_stocks

  # capitalize the ticker before saving it into the database
  before_save {self.ticker = ticker.upcase}

  # validations
  validates :name, :ticker, presence: true


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

    end # end exception handling

  end # end new_loockup method


  def self.check_db(ticker_symbol)
    # this method will check if a given ticker_symbol is already in the database. This mwthod is called from
    # the user_stocks_controller#create method.
    ticker_symbol.upcase!
    where(ticker: ticker_symbol).first

  end # end check_db


end # end stock
