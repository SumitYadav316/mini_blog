module Api
  module V1
    class PostsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!
      before_action :set_post, only: [:show, :update, :destroy]
      before_action :authorize_author!, only: [:create, :update, :destroy]

      def index
		  @posts = Post.includes(:comments).paginate(page: params[:page], per_page: 10)

		  render json: {
		    posts: ActiveModelSerializers::SerializableResource.new(@posts),
		    current_page: @posts.current_page,
		    total_pages: @posts.total_pages,
		    total_count: @posts.total_entries
		  }, status: :ok
      end

      def show
        render json: @post, status: :ok
      end

      def create
        @post = current_user.posts.build(post_params)
        if @post.save
          render json: { message: "Post created successfully", post: @post, post_details: PostSerializer.new(@post) }, status: :created

        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render json: { message: "Post updated successfully", post: @post, post_details: PostSerializer.new(@post) }, status: :ok
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        render json: { message: "Post deleted successfully" }, status: :no_content
      end

      private

      def set_post
        @post = Post.find_by(id: params[:id])
        render json: { error: 'Post not found' }, status: :not_found unless @post
      end

      def post_params
        params.require(:post).permit(:title, :content, :image)
      end

      def authorize_author!
        unless current_user.author?
          render json: { error: "You are not authorized to perform this action" }, status: :forbidden
        end
      end

    end
  end
end
