require 'rails_helper'

RSpec.describe User, type: :model do
  let(:password) { '123123' }
  let(:user) { create(:user, password: password) }
  let(:product_1) { create(:product, price: 1200, stock: 100) }
  let(:product_2) { create(:product, price: 1200, stock: 100) }
  let(:product_3) { create(:product, price: 1200, stock: 100) }
  let(:product_4) { create(:product, price: 1200, stock: 100) }
  let!(:order_1) { create(:order, user: user, product: product_1) }
  let!(:order_2) { create(:order, user: user, product: product_2) }
  let!(:order_3) { create(:order, user: user, product: product_3) }
  let!(:order_4) { create(:order, user: user, product: product_4) }

  it 'a valid user' do
    expect(user).to be_valid
    expect(user.digest_password).to eq(Digest::SHA256.hexdigest(password))
  end

  describe '#email' do
    it 'email is nil' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'email is invalid' do
      user.email = 'ddd@'
      expect(user).not_to be_valid
    end

    it 'email should be unique' do
      user2 = User.create(email: user.email, name: 'name', password: password)
      expect(user2.persisted?).to be_falsey
    end
  end

  it 'invalid password' do
    user.password = '12345'
    expect(user).not_to be_valid
    user.password = '123451234512345'
    expect(user).not_to be_valid
    user.password = '1234512345A'
    expect(user).not_to be_valid
  end

  describe '#authenticate' do
    it { expect(user.authenticate(password)).to be_truthy }
  end

  describe '#last_purchase_date' do
    it { expect(user.last_purchase_date).to eq(order_4.ready_at) }
  end

  describe '#customer_rank' do
    let(:user2) { create(:user) }
    let(:product2_1) { create(:product, price: 1000, stock: 100) }
    let(:product2_2) { create(:product, price: 1000, stock: 100) }
    let(:product2_3) { create(:product, price: 1000, stock: 100) }
    let(:product2_4) { create(:product, price: 1000, stock: 100) }
    let!(:order2_1) { create(:order, user: user2, product: product2_1) }
    let!(:order2_2) { create(:order, user: user2, product: product2_2) }
    let!(:order2_3) { create(:order, user: user2, product: product2_3) }
    let!(:order2_4) { create(:order, user: user2, product: product2_4) }
    let(:user3) { create(:user) }

    it { expect(user.customer_rank).to eq(1) }
    it { expect(user2.customer_rank).to eq(2) }
    it { expect(user3.customer_rank).to eq(0) }
  end
end
