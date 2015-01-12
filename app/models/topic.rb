class Topic < ActiveRecord::Base
  require_from_ce('models/topic')

  def notify_of_new_post(post)
    monitorships.where(:active => true).each do |m|
      UserNotifier.new_forum_post_notice(m.user, post).deliver if (m.user != post.user) && m.user.notify_comments
    end
  end

end
