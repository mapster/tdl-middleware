class Exercise < ActiveRecord::Base
    has_many :source_files, :as => :source_set, dependent: :destroy
    validates :name, presence: true, uniqueness: true
    validates :kind, :difficulty, :description, presence: true
end
