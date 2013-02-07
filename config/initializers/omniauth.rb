# The following keys and secrets must be filled in with actual
# data for the app to work. All of this data is available when
# creating a new application on the web site of any of these
# services.

TWITTER_CONSUMER_KEY = ""
TWITTER_CONSUMER_SECRET = ""
FACEBOOK_APP_ID = ""
FACEBOOK_APP_SECRET = ""
LINKEDIN_API_KEY = ""
LINKEDIN_SECRET = ""

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :scope => "publish_stream,email,offline_access"
  provider :linked_in, LINKEDIN_API_KEY, LINKEDIN_SECRET
end
