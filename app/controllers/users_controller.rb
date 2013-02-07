class UsersController < ApplicationController

  def show
    @user = current_user
  end

  def new_status
    @user = current_user
    
    if params[:twitter] != "1" && params[:facebook] != "1" && params[:linkedin] != "1"
      flash.now[:notice] = "You must select at least one service to send your status to."
      render :show
      return
    end
    
    if params[:twitter] == "1"
      twitter_auth = @user.authorizations.find_by_provider("twitter")
      post_to_twitter(twitter_auth.token, twitter_auth.secret, params[:status]) unless twitter_auth.nil?
    end
    
    if params[:facebook] == "1"
      facebook_auth = @user.authorizations.find_by_provider("facebook")
      post_to_facebook(facebook_auth.token, params[:status]) unless facebook_auth.nil?
    end

    if params[:linkedin] == "1"
      linkedin_auth = @user.authorizations.find_by_provider("linked_in")
      post_to_linkedin(linkedin_auth.token, linkedin_auth.secret, params[:status]) unless linkedin_auth.nil?
    end
    
    flash.now[:success] = "Status updated on the selected service(s)."
    
    render :show
  end
  
  private

    def post_to_twitter(oauth_token, oauth_token_secret, message)
      consumer = OAuth::Consumer.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, 
                                     :site => "http://api.twitter.com")
      # now create the access token object from passed values
      token_hash =
      {
        :oauth_token => oauth_token,
        :oauth_token_secret => oauth_token_secret
      }
      access_token = OAuth::AccessToken.from_hash(consumer, token_hash)

      response = access_token.post("http://api.twitter.com/1/statuses/update.json", 
                                   :status => message)

    end

    def post_to_facebook(oauth_token, message)
      consumer = OAuth2::Client.new(FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, 
                                     :site => "https://graph.facebook.com")

      access_token = OAuth2::AccessToken.new(consumer, oauth_token)
      response = access_token.post("/me/feed", :message => message)
    end
    
    def post_to_linkedin(oauth_token, oauth_token_secret, message)
      consumer = OAuth::Consumer.new(LINKEDIN_API_KEY, LINKEDIN_SECRET, 
                                     :site => "http://api.linkedin.com")
      # now create the access token object from passed values
      token_hash =
      {
        :oauth_token => oauth_token,
        :oauth_token_secret => oauth_token_secret
      }
      access_token = OAuth::AccessToken.from_hash(consumer, token_hash)

      response = access_token.put("http://api.linkedin.com/v1/people/~/current-status", 
                                  "<?xml version=\"1.0\" encoding=\"UTF-8\"?><current-status>#{message}</current-status>",
                                  {"Content-Type" => "text/xml"} )
    end
  
end
