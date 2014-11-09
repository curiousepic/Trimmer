class HomeController < ApplicationController
  before_action :set_client

  def index
    if logged_in?
      timeline_users = []
      timeline = @client.home_timeline(options = {count: 200})
      timeline.each do |t|
        timeline_users << { user_id: t.user.id,
                            user_name: t.user.name,
                            user_screen_name: t.user.screen_name}
      end
      user_list = []
      timeline_users.each do |t|
        user_index = user_list.find_index{ |h| h[:user_id] == t[:user_id] }
        if user_index == nil
          user_list << { user_id: t[:user_id],
                         user_name: t[:user_name],
                         user_screen_name: t[:user_screen_name],
                         tweet_count: 1}
        else
          user_list[user_index][:tweet_count] += 1
        end

      end
      @display_list = user_list.sort_by! { |u| u[:tweet_count]}.reverse
    end
  end


  def mute_friend
    @client.mute(mute_friend_params)
    redirect_to root_path
  end

  def unfollow_friend
    @client.unfollow(unfollow_friend_params)
    redirect_to root_path
  end

  private

  def set_client
    if logged_in?
      twitter_auth = current_user.authorizations.find_by(provider: 'twitter')
      if twitter_auth
        @client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_KEY']
          config.consumer_secret     = ENV['TWITTER_SECRET']
          config.access_token        = twitter_auth.token
          config.access_token_secret = twitter_auth.secret
        end
      end
    end
  end

  def mute_friend_params
    params.require(:friend_name)
  end

  def unfollow_friend_params
    params.require(:friend_name)
  end

end