class Product < ApplicationRecord
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0, }
  validates :stock, presence: true
  validates :stock, numericality: { greater_than: 0, }, on: :create
  validates :stock, numericality: { greater_than_or_equal_to: 0, }, on: :update
end
