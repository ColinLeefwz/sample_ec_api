require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  it 'be valid' do
    expect(product).to be_valid
  end

  describe '#price' do
    it 'price is nil' do
      product.price = nil
      expect(product).not_to be_valid
    end

    it 'price is not number' do
      product.price = 'fe'
      expect(product).not_to be_valid
    end

    it 'price equal to 0' do
      product.price = 0
      expect(product).not_to be_valid
    end
  end

  describe '#stock' do
    it 'name should be unique' do
      product2 = Product.create(name: product.name, brand: 'brand1', price: 100, stock: 0)
      expect(product2.persisted?).to be_falsey
    end
  end

  describe '#stock' do
    it 'stock is nil' do
      product.stock = nil
      expect(product).not_to be_valid
    end

    it 'stock is not number' do
      product.stock = 'fe'
      expect(product).not_to be_valid
    end

    it 'stock should be greater than 0 when create' do
      product2 = Product.create(name: 'product1', brand: 'brand1', price: 100, stock: 0)
      expect(product2.persisted?).to be_falsey
    end

    it 'stock can be equal to 0 when update' do
      product.update(stock: 0)
      expect(product.stock).to eq(0)
    end

    it 'stock should not be less than 0 when update' do
      stock = product.stock
      product.update(stock: -1)
      expect(product.reload.stock).to eq(stock)
    end
  end
end
