class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :password_digest, :admin
  has_many :user_stories
   class UserStorySerializer < ActiveModel::Serializer
     attributes :id, :user_id, :story_id
   end
end
