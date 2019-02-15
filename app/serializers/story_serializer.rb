class StorySerializer < ActiveModel::Serializer
  attributes :id, :website_id, :category_id, :title, :subtext, :image, :link
  has_many :user_stories
    class UserStorySerializer < ActiveModel::Serializer
      attributes :id
    end
  has_many :users, through: :user_stories
  class UsersSerializer < ActiveModel::Serializer
    attributes :id
  end
  
  belongs_to :category
  belongs_to :website
end
