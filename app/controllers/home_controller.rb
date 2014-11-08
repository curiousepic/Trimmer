class HomeController < ApplicationController
  def index
    if logged_in?
      twitter_auth = current_user.authorizations.find_by(provider: 'twitter')
      if twitter_auth
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_KEY']
          config.consumer_secret     = ENV['TWITTER_SECRET']
          config.access_token        = twitter_auth.token
          config.access_token_secret = twitter_auth.secret
        end
        @user_list = []
        @timeline = client.home_timeline(options = {count: 200})
        @timeline.each do |t|
          @user_list << { user_id: t.user, user_name: t.user.name , user_screen_name: t.user.screen_name }
        end
      end
    end
  end
end
