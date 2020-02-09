class AccountActivationsController < ApplicationController
  def edit
    user = User.where(email: params[:email]).first
    if user && !user.active? && user.authenticated?(:activation, params[:id])
      user.activate
      login(user)
      flash[:success] = 'Account is successfully Activated!'
    else
      flash[:danger] = 'The activation link is not valid'
    end
    redirect_to root_path
  end
end
