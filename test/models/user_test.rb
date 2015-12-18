require 'test/unit'

#class UserTest < Test::Unit::TestCase
class UserTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_new_user
    @user       = User.new()
    @user.role  = Role[:member]
    @user.email = "unit_test@infrno.net"
    @user.first_name = "unit_test_first_name"
    @user.last_name = "unit_test_last_name"
    @user.birthday = "1984-05-24"
    @user.crypted_password = "$2a$10$lpoOkwFJS5f5psAft6Xc6evx4gSlE/brkhHNvQINMuZLsJQHCuewy"
    @user.password_salt = "TuARRCvTL1Ie6VMXvx0"
    @user.login = User.create_unique_login("last_name")

    assert @user.save!
  end

  def test_hash_validation
    sha2 = Digest::SHA2.new
    hash_input = "unit_test@infrno.net" + D20PRO_SECRET
    sha2.update hash_input
    hash = sha2.hexdigest
  end
end