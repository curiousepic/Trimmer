class HomeController < ApplicationController
  def index
    if logged_in?
      twitter_auth = current_user.authorizations.find_by(provider: 'twitter')
      if twitter_auth
        ## Old HTTParty get method
        # response = HTTParty.get("https://api.twitter.com/1.1/statuses/home_timeline.json",
        #                         { authorization: "token #{twitter_auth.token}" })
        # @timeline = JSON.parse(response.body)

        # new Twitter Ruby gem method
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_KEY']
          config.consumer_secret     = ENV['TWITTER_SECRET']
          config.access_token        = twitter_auth.token
          config.access_token_secret = twitter_auth.secret
        end
        # @timeline = client.home_timeline
        # render :json => @timeline = client.home_timeline(options = {count: 200})
      end
    end
  end
end
