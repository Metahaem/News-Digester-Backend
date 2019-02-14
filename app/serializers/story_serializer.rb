class StorySerializer < ActiveModel::Serializer
  attributes :id, :website_id, :category_id, :title, :text, :subtext, :image, :link
  has_many :user_stories
    class UserStorySerializer < ActiveModel::Serializer
      attributes :id
    end
  
      

  belongs_to :category
  belongs_to :website
end
