class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  has_secure_password

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, length: { minimum: 6 }

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
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

end
