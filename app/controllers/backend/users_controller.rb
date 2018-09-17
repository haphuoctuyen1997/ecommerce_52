class Backend::UsersController < Backend::BaseController
  before_action :load_user, except: %i(index new create)
  before_action :load_roles, except: %i(index show destroy)

  def edit; end

  def index
    @users = User.newest
    @users = if params[:search].present?
               @users.search(params[:search])
             else
               @users
             end
             .paginate page: params[:page],
                per_page: Settings.admin_user_perpage
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".user_updated"
      redirect_to backend_users_path
    else
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".user_create"
      redirect_to backend_users_path
    else
      render :new
    end
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_delete_fail"
    end
    redirect_to backend_users_path
  end

  def role
    @user.admin? ? @user.member! : @user.admin!
    respond_to do |format|
      format.json{render json: {user: @user}}
      format.html
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :address, :phone, :role
  end

  def load_user
    @user = User.find params[:id]
  end

  def load_roles
    @roles = User.roles
  end
end
