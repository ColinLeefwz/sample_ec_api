class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  delegate :id, :name, :brand, to: :product, prefix: true

  before_save :set_ready_at
  after_create :decrement_product_stock

  def self.total_purchased_amount_rank
    joins(:product).order('sum_products_price desc').group(:user_id).sum("products.price")
  end

  private

  def decrement_product_stock
    product = Product.find(product_id)
    product.decrement(:stock)
    raise ActiveRecord::Rollback unless product.save
  end

  def set_ready_at
    self.ready_at = Time.now
  end
end
