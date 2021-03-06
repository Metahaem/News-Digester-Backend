class User < ApplicationRecord
    has_many :user_stories
    has_many :stories, through: :user_stories

    has_secure_password
    validates :name, uniqueness: { case_sensitive: false }

    
end
