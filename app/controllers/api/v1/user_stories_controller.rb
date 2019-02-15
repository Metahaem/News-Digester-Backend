class Api::V1::UserStoriesController < ApplicationController
    before_action :find_user_story, only: [:show, :edit, :update, :destroy]
      
    def index
        @user_stories = UserStory.all
        render json: @users_stories
    end
    
    
    def create
        @user_story = UserStory.new(user_story_params)
        if @user_story.valid? && @user_story.save
            render json: { user_story: UserStorySerializer.new(@user_story) }, status: :created        
        else
          render json: {error: "Unable to create user_story."}, status: :not_acceptable
        end
    end


      def delete
        @user_story = UserStory.find{|user_story| (user_story.user_id == params[:user_id]) && (user_story.story_id == params[:story_id])}
        @user_story.destroy
    end

    
      private
    
        def user_story_params
          params.permit(:user_id, :story_id, :user_story)
        end
    
        def find_user_story
          @user_story = UserStory.find(params[:id])
        end

end
