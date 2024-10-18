module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post

      def index
        comments = @post.comments
        render json: comments, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: :not_found
      end
    end
  end
end
