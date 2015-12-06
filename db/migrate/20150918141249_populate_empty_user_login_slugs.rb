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

    execute "update users set crypted_password = 'c285a893dccd7411b88e7d65fbec3f8a61f9761b' where crypted_password is null;"
    execute "update users set password_salt = 'bf4d375c51319cd8246bc7ab28d03f2ce2615e3b' where password_salt is null;"
    execute "update users set birthday = '1984-05-24' where birthday is null;"

    User.where("login_slug is null").each do |u|
      puts "> null login_slug: #{u.id}, #{u.login}, #{u.email}"
      u.login_slug = u.login.tr(" ", "_")
      u.save!
    end

  end
end
