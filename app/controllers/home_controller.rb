class HomeController < ApplicationController
  def index
    if logged_in?
      twitter_auth = current_user.authorizations.find_by(provider: 'twitter')
      if twitter_auth
        response = HTTParty.get("https://api.twitter.com/1.1/statuses/home_timeline.json",
                                { authorization: "token #{twitter_auth.token}" })
        @home = JSON.parse(response.body)
      end
    end
  end
end
