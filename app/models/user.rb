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



  def self.matches(field_name, param)
    # this method will be used to search on a field_name(first name, last name, email) for a specific query(param)
    # It will be used by the methods below to search each field_name individually
    where("#{field_name} like ?", "%#{param}%")
  end


  def self.search(param)
    # this method will execute the search of a term through multiple "options" (first name, last name and email)
    # first it strips out any spaces from the param and the it runs the three methods below:
    # first_name_matches, last_name_matches and email_matches. Then, it filters only for unique results and
    # saves the value to the variable to_send_back. If nothing returns, then the method returns nil, otherwise, it returns
    # the value that was stored.
    param.strip!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    to_send_back.nil? ? nil : to_send_back
    #return  nil unless to_send_back
    #to_send_back
  end

  def self.first_name_matches(param)
    # please refer to method above to understand the logic
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    # please refer to method above to understand the logic
    matches('last_name', param)
  end

  def self.email_matches(param)
    # please refer to method above to understand the logic
    matches('email', param)
  end

  def except_current_user(friends)
    # this method removes the current user from the friends Result Set and it's called from the users_controller.
    # It will loop through the friends list and compare the id with the id of the current_user (method from DEVISE)
    # if the ID is the same, then it removes it from the ResultSet

    friends.reject { |friend| friend.id == self.id }
  end

  def not_friends_with?(id_of_friend)
    # this method will run a query to see if the relationship friendship exists between the user and the id of the friend.
    # This methos is called from the _friend_result_html.erb
    # Here is how the query breakdown looks like
    #   * list all friends for the user - user.friends
    #   * look if one of the friends has the ID that was passed in check if it exists
    #   * if the friend is found, it returns true
    #   * then I inverted the result to make it more readible so if the query returns true, the it means that they are friends
    #
    !self.friends.where(id: id_of_friend).exists?
  end

end
