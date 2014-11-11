module HomeHelper
  def sorted_user_list(client)
    timeline = get_timeline(client)
    user_list(timeline).sort_by! { |u| u[:tweet_count] }.reverse
  end

  def get_timeline(client)
    timeline_users = []
    timeline = client.home_timeline(options = { count: 200 })
    timeline.each do |t|
      timeline_users << { user_name: t.user.name,
                          user_screen_name: t.user.screen_name }
    end
    timeline_users
  end

  def user_list(timeline)
    user_list = []
    timeline.each do |t|
      build_and_count_user_list(t, user_list)
    end
    user_list
  end

  def build_and_count_user_list(t,l)
    user_index = l.find_index { |h| h[:user_name] == t[:user_name] }
    if user_index.nil?
      l << { user_name: t[:user_name],
                     user_screen_name: t[:user_screen_name],
                     tweet_count: 1 }
    else
      l[user_index][:tweet_count] += 1
    end
  end
end
