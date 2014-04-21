class UsersController < ApplicationController
  before_action :check_is_manager

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to users_path, flash: { success: "User created" }
    else
      flash[:error] = "There was an error creating the user"
    end
  end

  def destroy
    delete_user = User.find(params[:id])
    if current_user.id != delete_user.id && delete_user.delete
      redirect_to users_path, flash: {success:  "Successfully removed user"}
    else
      flash[:error] = "There was an error removing this user"
      redirect_to users_path, flash: {error:  "There was an error removing this user"}
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

end
