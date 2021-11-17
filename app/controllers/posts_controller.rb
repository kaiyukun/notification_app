class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @post = Post.new
    @posts = Post.all
  end

  def new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.user_uid = current_user.uid
    if @post.save
      redirect_to posts_path
    else
      redirect_to new_post_path
    end
  end

  def show
  end

  private
  def post_params
    params.require(:post).permit(:body, :endday)
  end

end
