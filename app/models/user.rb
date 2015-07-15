class User < ActiveRecord::Base
    acts_as_authentic
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    def as_json(options)
        super(:only => [:name, :email])
    end
end
