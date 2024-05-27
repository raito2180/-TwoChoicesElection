class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new 
    @post = Post.new
  end

  def create
    @post = current_user.profile.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: '募集を投稿しました'
    else
      flash.now[:danger] = '募集の投稿に失敗しました'
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :date, :location, :detail, :capacity, :related_url )
  end


end
