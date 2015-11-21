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
    if User.exists?(17869)
      User.find(17869).destroy
    end
    User.where("login_slug is null").each do |u|
      puts "> null login_slug: #{u.id}, #{u.login}, #{u.email}"
      u.login_slug = u.login.tr(" ", "_")
      u.save!
    end
  end
end
