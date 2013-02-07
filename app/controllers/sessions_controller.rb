class SessionsController < ApplicationController

  def new
  end
  
  def destroy
    signout
    flash[:notice] = "You have been signed out."
    redirect_to root_path
  end
  
  def create
    auth = request.env['omniauth.auth']

    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end

    self.current_user = @auth.user
    redirect_to current_user
  end
  
end
