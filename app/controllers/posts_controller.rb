class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # after_action :expire_cache, only: [:create, :update, :destroy]
  
  include Pundit

  def index
    @posts = if params[:query].present?
               Post.search_by_title_and_body(params[:query]).paginate(page: params[:page], per_page: 5)
             else
               Post.paginate(page: params[:page], per_page: 5)
             end
    authorize @posts
  end

  def show
    @comment = @post.comments.build
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def expire_cache
    Rails.cache.delete('homepage_posts')
  end
end
