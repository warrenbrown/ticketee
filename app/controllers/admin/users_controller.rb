class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:email)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'User has been saved.'
      redirect_to admin_users_path
    else
      flash.now[ :alert ] = 'User has not been saved'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
    end

    if @user.update(user_params)
      flash[ :notice ] = 'User has been updated.'
      redirect_to admin_users_path
    else
      flash.now[ :alert ] = 'User has not been updated.'
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end
end
