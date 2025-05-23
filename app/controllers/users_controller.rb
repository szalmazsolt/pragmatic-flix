class UsersController < ApplicationController
  before_action :require_signin, except: [ :new, :create ]
  before_action :require_correct_user, only: [ :edit, :update ]
  before_action :require_admin, only: [ :destroy ]

  def index
    @users = User.by_name
  end

  def show
    @user = User.find_by!(username: params[:id])
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by!(username: params[:id])
    user.destroy
    redirect_to root_url, status: :see_other, alert: "The account was deleted!"
  end

  private
    def user_params
      params
        .require(:user)
        .permit(:name, :username, :email, :password, :password_confirmation)
    end
end
