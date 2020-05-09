class User < ApplicationRecord
  attr_accessor :password

  before_save :encrypt_password

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6, maximum: 12 }, format: { with: /\A[a-z0-9]+\z/ }

  enum role: { customer: 0, admin: 1 }

  protected

  def encrypt_password
    return if password.blank?

    self.digest_password = encrypt(password)
  end

  def encrypt
    Digest::SHA256.hexdigest(password)
  end
end
