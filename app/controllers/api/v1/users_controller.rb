class Api::V1::UsersController < ApplicationController
    before_action :find_user, only: [:show, :edit, :update, :destroy, :stories]
    def index
        @users = User.all
        render json: @users
      end
    
      def show
        render json: @user
      end
    
      def create
        @user = User.new(name: params[:name])
        if @user.valid? && @user.save
            render json: { user: UserSerializer.new(@user) }, status: :created        
        else
          render json: {error: "Unable to create user."}, status: :not_acceptable
        end
      end

      def destroy
        @user.destroy
        redirect_to users_path
      end

      def stories
        render json: @user.stories
      end
    
    
      private
    
        def user_params
          params.permit(:name, :id)
        end
    
        def find_user
          @user = User.find(params[:id])
        end

        
end
