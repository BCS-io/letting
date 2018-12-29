####
#
# UsersController
#
# Why does this class exist?
#
# Restful action of the Users resource
#
# How does this fit into the larger system?
#
# Only admins are permitted to access the users controller and manage them.
#
####
#
class UsersController < ApplicationController
  def index
    @users = User.by_nickname.page(params[:page]).load
  end

  def show
    @user = UserDecorator.new User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new users_params
    if @user.save
      redirect_to users_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update users_params
      redirect_to users_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @user = User.find params[:id]
    cached_message = deleted_message
    @user.destroy
    redirect_to users_path, flash: { delete: cached_message }
  end

  private

  # users_params
  #   - white listing of user supplied data
  #
  def users_params
    params.require(:user).permit user_attributes
  end

  def user_attributes
    %i[nickname email password password_confirmation role]
  end

  def identity
    "User #{@user.email}"
  end
end
