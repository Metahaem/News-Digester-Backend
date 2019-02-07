class Api::V1::CategoriesController < ApplicationController
    before_action :find_category, only: [:show, :edit, :update, :destroy]
    def index
        @category = Category.all
        render json: @category
      end
    
      def show
        @category = Category.find(params[:id])
        render json: @category
      end
    
      def create
        @category = Category.new(name: params[:name])
        if @category.valid? && @category.save
          render json: @category
        else
          render json: {error: "Unable to create category."}, status: 400
        end
      end
    
      private
    
        def user_params
          params.permit(:name)
        end
    
        def find_category
          @category = Category.find(params[:id])
        end

        
end

