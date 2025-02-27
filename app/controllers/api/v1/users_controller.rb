module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: current_user
      end

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        @current_user = User.find_by(token: token)

        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
