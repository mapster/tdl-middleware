class User < ActiveRecord::Base
    acts_as_authentic
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    has_one :user_authorization

    def as_json(options = nil)
        super(:only => [:name, :email])
    end
end
