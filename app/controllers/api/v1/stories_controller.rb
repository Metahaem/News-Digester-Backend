class Api::V1::StoriesController < ApplicationController
    before_action :find_story, only: [:show, :edit, :update, :destroy]
    def index
        @stories = Story.all
        render json: @stories
      end
    
      def show
        render json: @story
      end
    
      def create
        @story = Story.new(story_params)
        if @story.valid? && @story.save
          render json: @story
        else
          render json: {error: "Unable to create story."}, status: 400
        end
      end

      def scrape_all
        Story.destroy_all
        Bbc.scrape_all_categories
        Independent.scrape_all_categories
        # Sky.scrape_all_categories
        # Huff_post.scrape_all_categories
        Guardian.scrape_all_categories
        render json: @stories
    end
    
    private
    
      def story_params
        params.permit(:title, :subtext, :image, :link, website_id, category_id)
      end
    
      def find_story
        @story = Story.find(params[:id])
      end
    


end
