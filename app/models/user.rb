class User < ActiveRecord::Base
    acts_as_authentic do |c|
        c.logged_in_timeout(UserSession::LOGGED_IN_TIMEOUT)
    end

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    has_one :user_authorization
    has_many :solutions
end
