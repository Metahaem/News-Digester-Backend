class Story < ApplicationRecord
    has_many :user_stories
    has_many :users, through: :user_stories
    belongs_to :category
    belongs_to :website
end
