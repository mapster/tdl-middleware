class Exercise < ActiveRecord::Base
    has_many :source_files, dependent: :destroy
    validates :name, presence: true, uniqueness: true
    validates :title, :kind, :difficulty, :description, presence: true
end
