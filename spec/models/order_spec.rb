require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product) { create(:product, stock: 1) }

  describe '.create' do
    it 'create a record successfully' do
      timestamp = Time.local(2020, 5, 10)
      Timecop.freeze(timestamp)
      order = described_class.create(user: user, product: product)

      expect(order.persisted?).to be_truthy
      expect(order.ready_at).to eq(timestamp)
      expect(product.reload.stock).to eq(0)

      Timecop.return
    end

    it 'create failed because of stock out' do
      order1 = described_class.create(user: user, product: product)
      expect(order1.persisted?).to be_truthy
      order2 = described_class.create(user: user, product: product)
      expect(order2.persisted?).to be_falsey
    end
  end

  describe '.total_purchased_amount_rank' do
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
    let(:product3_1) { create(:product, price: 2000, stock: 100) }
    let(:product3_2) { create(:product, price: 2000, stock: 100) }
    let(:product3_3) { create(:product, price: 2000, stock: 100) }
    let(:product3_4) { create(:product, price: 2000, stock: 100) }
    let!(:order3_1) { create(:order, user: user3, product: product3_1) }
    let!(:order3_2) { create(:order, user: user3, product: product3_2) }
    let!(:order3_3) { create(:order, user: user3, product: product3_3) }
    let!(:order3_4) { create(:order, user: user3, product: product3_4) }
    let!(:result) {
      {
        user3.id => 8000,
        user2.id => 4000,
      }
    }

    it { expect(described_class.total_purchased_amount_rank).to eq(result) }
  end
end
