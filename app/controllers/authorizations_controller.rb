class AuthorizationsController < ApplicationController

  def destroy
    @auth = Authorization.find(params[:id])
    @auth.destroy
    
    if !signed_in?
      signout
      flash[:notice] = "You have been signed out because you deleted all of your authorized services."
      redirect_to root_url
    else
      redirect_to current_user
    end
  end
  
end
