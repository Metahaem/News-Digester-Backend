class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :password_digest
  has_many :user_stories
   class UserStorySerializer < ActiveModel::Serializer
     attributes :id
   end
end
