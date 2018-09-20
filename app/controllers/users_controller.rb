class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show
    @suggests = Suggest.feed_user_id(current_user.id)
  end

  private
  def load_user
    @user = User.find params[:id]
  end
end
