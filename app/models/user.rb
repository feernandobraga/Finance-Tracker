class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # the lines below create the many to many association.
  # It's important to include "through" as it allows for functionalities like
  # stock.users and also user.stocks
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships


  def under_stock_limit?
    # the method simply executes user.stocks.count and returns
    # true or false if the counter is greater than 9

    stocks.count < 10

  end # end under_stock_limit?


  def stock_already_tracked?(ticker_symbol)
    #this method will check if the stock is already been tracked.

    # if the stock is not even on the database, just return false
    # the method check_db comes from the Stock model
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    # if the stock is in fact in the DB, I have to check if the user is already tracking it
    # for example, user.stocks.where(id: 13).exists?
    # This will test if there's an association between the logged user and the stock id passed through
    stocks.where(id: stock.id).exists?
  end


  def can_track_stock?(ticker_symbol)
    # the method will evaluate if the user can track or not the stock based on the two methods above the verify if
    # the user is tracking less than 10 stocks and if he/she is not already tracking that stock

    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end


  def full_name
    # this method returns the first_name and last_name from the model to the navbar.
    first_name || last_name ? "#{first_name} #{last_name}" : "Anonymous"
  end


end
