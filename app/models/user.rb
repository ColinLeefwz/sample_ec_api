class User < ApplicationRecord
  has_many :orders
  has_many :products, through: :orders
  attr_accessor :password

  before_save :encrypt_password

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6, maximum: 12 }, format: { with: /\A[a-z0-9]+\z/ }

  enum role: { customer: 0, admin: 1 }

  def authenticate(password)
    self.digest_password == encrypt(password)
  end

  def last_purchase_date
    last_order = orders.order(ready_at: :desc).first
    last_order&.ready_at
  end

  def customer_rank
    rank_index = Order.total_purchased_amount_rank.keys.index(id)
    return 0 if rank_index.nil?

    rank_index + 1
  end

  protected

  def encrypt_password
    return if password.blank?

    self.digest_password = encrypt(password)
  end

  def encrypt(password)
    Digest::SHA256.hexdigest(password)
  end
end
