class FriendshipsController < ApplicationController

  def create
    # this method is called from the partial _friend_result.html.erb when the user clicks on the Follow button.
    # The breakdown is as per below:
    #   * grabs the user from the params and store it in a variable called friend
    #   * add the friend ID to the friendship table. The build method will also include the current_user id
    #   * if it saves to the DB, display a success message, otherwise displays something else

    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)

    if current_user.save
      flash[:notice] = "Your are now following #{friend.full_name}"
    else
      flash[:alert] = "Something went wrong with the friendship request"
    end # end if current_user.save

    redirect_to my_friends_path
  end # end create

  def destroy
    # this method will be called from the remove button in the friends/_list.html.erb and the buttons passes in
    # the friend object. The method breakdown is as per below:
    #   * find the Friend based on the Friend id given from the button. Remember, Friend is just another user
    #   * use the current_user method (from DEVISE helper) to get the user
    #   * find the relationship that has the user_id equals to the current_user and the friend_id equals to the friend
    #   * then I store it in a variable called friendship and destroy it

    friend = User.find(params[:id])
    friendship = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
    friendship.destroy
    flash[:notice] = "Stopped following"
    redirect_to my_friends_path

  end # end destroy

end
