require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:user) { create(:user) }
  let(:product_1) { create(:product, stock: 100) }
  let(:product_2) { create(:product, stock: 1) }
  let!(:order) { create(:order, user: user, product: product_1) }

  describe '#purchase' do
    let(:result) {
      {
        transaction_id: order.id,
        purchased_date: order.ready_at,
      }
    }
    let(:wrong_result) {
      {
        error_message: "#{product_2.name} is out of stock",
      }
    }

    it 'is successful' do
      expect(Order).to receive(:create!).and_return(order)
      post order_purchase_path(user, product_1), xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'stock out' do
      post order_purchase_path(user, product_2), xhr: true
      expect(response).to be_successful

      post order_purchase_path(user, product_2), xhr: true
      expect(response.body).to eq(wrong_result.to_json)
      expect(response.status).to eq(422)
    end
  end
end
