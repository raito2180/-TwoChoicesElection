class PostsController < ApplicationController
  before_action :redirect_root, only: [:new, :show, :edit, :destroy]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @group = @post.group
    @membership = @post.group.memberships.find_by(profile: current_user.profile, status: '参加')
    @participating_profiles = @group.memberships.where(status: :参加).includes(:profile)
    @interested_profiles = @group.memberships.where(status: :興味あり).includes(:profile)
    @not_participating_profiles = @group.memberships.where(status: :不参加).includes(:profile)
    if mobile_device?
      render :show
    else
      render :show_pc
    end
  end

  def new 
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.profile.posts.new(post_params)
    if @post.save
      group = Group.new(post: @post)
      if group.save
        membership = Membership.new(profile_id: current_user.profile.id, group: group, status: :参加)
        if membership.save
          redirect_to @post, notice: '募集投稿が作成されました。'
        else
          @post.destroy
          group.destroy
          render :new, alert: 'Membershipの作成に失敗しました。'
        end
      else
        @post.destroy
        render :new, alert: 'Groupの作成に失敗しました。'
      end
    else
      flash.now[:error] = '募集投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
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
      flash[:danger] = '募集投稿の削除に失敗しました'
    end
    redirect_to @post
  end

  private

  def post_params
    params.require(:post).permit(:title, :date, :location, :detail, :capacity, :related_url )
  end

end
