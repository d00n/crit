class PopulateEmptyUserLoginSlugs < ActiveRecord::Migration
  def change
    if User.exists?(:id => 6888)
      User.find(6888).destroy
    end
    if User.exists?(6889)
      User.find(6889).destroy
    end
    if User.exists?(11931)
      User.find(11931).destroy
    end
    User.where("login_slug is null").each do |u|
      puts "> #{u.id}, #{u.login}"
      u.login_slug = u.login.tr(" ", "_")
      u.save!
    end
  end
end
