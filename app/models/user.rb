class User < ActiveRecord::Base
    acts_as_authentic

    def as_json(options)
        super(:only => [:name, :email])
    end
end
