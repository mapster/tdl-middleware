class UserSession < Authlogic::Session::Base
  LOGGED_IN_TIMEOUT = 1.day

  before_destroy :reset_persistence_token
  before_create  :reset_persistence_token

  remember_me true
  remember_me_for LOGGED_IN_TIMEOUT

  logout_on_timeout true

  def reset_persistence_token
    record.reset_persistence_token
  end

end
