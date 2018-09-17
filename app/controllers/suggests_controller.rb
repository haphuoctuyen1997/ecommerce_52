class SuggestsController < ApplicationController
  before_action :logged_in_user, only: %i(create new)
  before_action :category_all, only: %i(create new)

  def index; end

  def new
    @suggest = Suggest.new
  end

  def create
    @suggest = Suggest.new suggests_params
    if @suggest.save
      flash[:success] = t ".new_suggest"
      redirect_to root_path
    else
      flash[:danger] = t ".not_suggest"
      render :new
    end
  end

  private

  def suggests_params
    params.require(:suggest)
          .permit :user_id, :name, :description, :category_id
  end
end
