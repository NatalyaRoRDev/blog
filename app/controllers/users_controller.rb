class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Добро пожаловать в Мотивашки!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #обрабатывает успешное обновление
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end

  #Подтверждает вход пользователя
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Пожалуйста, войдите на сайт'
      redirect_to login_url
    end
  end

  # Подтверждает правильного пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
