class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_path
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      login @user
      @user.update(:reset_digest, nil)
      flash[:success] = 'Password has been reset.'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.active? && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.pass_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
