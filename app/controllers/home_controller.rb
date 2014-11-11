class HomeController < ApplicationController
  before_action :set_client
  include HomeHelper

  def index
    return unless logged_in?
    @display_list = sorted_user_list(@client)
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
    return unless logged_in?
    twitter_auth = current_user.authorizations.find_by(provider: 'twitter')
    return unless twitter_auth
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = twitter_auth.token
      config.access_token_secret = twitter_auth.secret
    end
  end

  def mute_friend_params
    params.require(:friend_name)
  end

  def unfollow_friend_params
    params.require(:friend_name)
  end
end
