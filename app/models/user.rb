class User < ActiveRecord::Base
    acts_as_authentic
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    has_one :user_authorization
end
