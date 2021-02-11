class PasswordResetsController < ApplicationController
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
end
