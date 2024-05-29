class PostsController < ApplicationController
  before_action :redirect_root, only: [:new, :edit, :destroy]

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

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '募集投稿を更新しました'
    else
      flash.now[:danger] = '募集投稿の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = '募集投稿が削除されました'
    else
      flash[:error] = '募集投稿の削除に失敗しました'
    end
    redirect_to @post
  end

  private

  def post_params
    params.require(:post).permit(:title, :date, :location, :detail, :capacity, :related_url )
  end

end
