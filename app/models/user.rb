class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :age, presence: true
  validates :city, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Возвращает дайджест данной строки.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Возвращает случайный токен
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Запоминает пользователя в базе данных для использования в постоянной сессии.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Возвращает true, если предоставленный токен совпадает с дайджестом.
  def authenticated?(remember_token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Активирует аккаунт
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Отправляет активационное письмо
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Устанавливает атрибуты для сброса пароля
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Отправляет электронное письмо для сброса пароля
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

    # Переводит адрес электронной почты в нижний регистр.
    def downcase_email
      self.email = email.downcase
    end

    # Создает и присваивает активационнй токен и дайджест.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
