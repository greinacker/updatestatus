class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    return !(current_user == nil || current_user.authorizations.count == 0)
  end
  
  def signout
    session[:user_id] = nil
  end

  helper_method :current_user, :signed_in?, :signout

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

end
