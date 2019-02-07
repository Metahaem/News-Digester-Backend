class UserStorySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :story_id
  belongs_to :story
  belongs_to :user
end
