module Helpers
  module Authentication
    def sign_in_as(user)
      session[:user_id] = user.id
      session[:expires_at] = Time.now + 30.hours
    end
  end
end
