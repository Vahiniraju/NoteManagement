module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    session[:expires_at] = Time.now + 24.hours
  end

  def current_user
    if (user_id = session[:user_id]) && (session[:expires_at] > Time.now)
      @current_user ||= User.where(id: user_id).first
    elsif (user_id = cookies.signed[:user_id])
      user = User.where(id: user_id).first
      if user&.authenticated?(:remember, cookies[:remember_token]) && user.active?
        login user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def remember_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
