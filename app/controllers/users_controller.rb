class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :mailable)
  end

  def logged_in_user
    return if logged_in?

    remember_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  def user_permission
    @user = User.where(id: params[:id]).first
    return if @user == current_user

    flash[:danger] = 'You are not authorized'
    redirect_to root_path
  end

  def valid_user
    @user = User.where(id: params[:id]).first
    return unless @user.nil?

    redirect_to root_path
  end
end
