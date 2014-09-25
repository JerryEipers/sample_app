class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def new    #for loading the New page and pre-populating with data
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create  #for the Post action from the New page
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit    #for loading the Edit page and pre-populating with user data
    # note, pre-populated user info comes from the before_action :correct_user
  end

  def update   #for the Patch action from the Edit page
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  										:password_confirmation)
  	end

    #Before_action filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
