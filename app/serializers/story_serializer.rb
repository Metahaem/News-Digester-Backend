class StorySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :category_id, :title, :subtext, :image, :link
  has_many :user_stories
    class UserStorySerializer < ActiveModel::Serializer
      attributes :id
    end
  
      

  belongs_to :category
  belongs_to :website
end

20-47-34
93197573