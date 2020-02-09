class SessionsController < ApplicationController
  def new; end

  def create
    user = User.where(email: params[:session][:email]).first
    if user&.authenticate(params[:session][:password])
      if user.active?
        flash[:success] = 'Welcome to Note Management'
        login user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_path
      else
        flash[:warning] = 'Account not activated. Check your email for the activation link.'
        redirect_to root_path
      end

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
