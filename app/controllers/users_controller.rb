class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, only: :show

  def show
    @suggests = Suggest.feed_user_id(current_user.id)
  end
end
