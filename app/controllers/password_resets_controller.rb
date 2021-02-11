class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Электронное письмо с инструкциями 
      по сбросу пароля отправлено на вашу электронную почту"
      redirect_to root_url
    else
      flash.now[:danger] = "Данный адрес электронной почты не найден"
      render 'new'
    end
  end

  def edit
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Подтверждает валидность пользователя.
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
end
