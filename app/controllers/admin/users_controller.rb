class Admin::UsersController < ApplicationController
  before_action :set_projects, only: [ :new, :create, :update, :edit ]

  skip_after_action :verify_authorized, :verify_policy_scoped

  before_action :set_user, only: [:show, :edit, :update, :archive]

  def index
    @users = User.excluding_archived.order(:email)
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

    User.transaction do
      @user.roles.clear
      role_data = params.fetch(:roles, [])
      role_data.each do |project_id, role_name|
        if role_name.present?
          @user.roles.build(project_id: project_id, role: role_name)
        end
      end

      if @user.update(user_params)
        flash[ :notice ] = 'User has been updated.'
        redirect_to admin_users_path
      else
        flash.now[ :alert ] = 'User has not been updated.'
        render 'edit'
        raise ActiveRecord::Rollback
      end
    end
  end

  def archive
    if @user == current_user
      flash[:alert] = "You can not archive yourself!"
    else
      @user.archive
      flash[ :notice ] = 'User has been archived'
    end
    redirect_to admin_users_path
  end

  private
  def set_projects
    @projects = Project.order(:name)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end
end
