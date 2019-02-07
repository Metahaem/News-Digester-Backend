class Api::V1::WebsitesController < ApplicationController
    before_action :find_website, only: [:show, :edit, :update, :destroy]
    def index
        @website = Website.all
        render json: @website
      end
    
      def show
        @website = Website.find(params[:id])
        render json: @website
      end
    
      def create
        @website = Website.new(name: params[:name])
        if @website.valid? && @website.save
          render json: @website
        else
          render json: {error: "Unable to create website."}, status: 400
        end
      end
    
      private
    
        def user_params
          params.permit(:name)
        end
    
        def find_website
          @website = Website.find(params[:id])
        end

        
end
