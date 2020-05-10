require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:password) { '123123' }
  let(:user) { create(:user, password: password) }
  let(:product_1) { create(:product, price: 1200, stock: 100) }
  let(:product_2) { create(:product, price: 1200, stock: 100) }
  let(:product_3) { create(:product, price: 1200, stock: 100) }
  let!(:order_1) { create(:order, user: user, product: product_1) }
  let!(:order_2) { create(:order, user: user, product: product_2) }
  let(:admin) { create(:user, :admin) }
  let(:auth) { JsonWebToken.encode(user_id: admin.id) }
  let(:user_auth) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => auth } }
  let(:user_headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => user_auth } }
  let(:wrong_headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => "wrong_token" } }

  describe '#index' do
    let(:result) {
      [
        {
          id: product_1.id,
          name: product_1.name,
          brand: product_1.brand,
          price: product_1.price,
          stock: product_1.stock - 1,
        },
        {
          id: product_2.id,
          name: product_2.name,
          brand: product_2.brand,
          price: product_2.price,
          stock: product_2.stock - 1,
        },
      ]
    }

    it 'is successful' do
      get products_path, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:name) { 'product name' }
    let(:brand) { 'product brand' }
    let(:result) {
      {
        id: product_3.id,
        name: product_3.name,
        brand: product_3.brand,
        price: product_3.price,
        stock: product_3.stock,
      }
    }

    it 'create product successfully' do
      expect(Product).to receive(:create!).and_return(product_3)
      post products_path, params: { name: name, brand: brand, price: 1000, stock: 10 }.to_json, headers: headers, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'no auth header' do
      post products_path, params: { name: name, brand: brand, price: 1000, stock: 10 }.to_json, xhr: true
      expect(response.body).to eq({ errors: 'Nil JSON web token' }.to_json)
      expect(response.status).to eq(401)
    end

    it 'wrong auth token' do
      post products_path, params: { name: name, brand: brand, price: 1000, stock: 10 }.to_json, headers: wrong_headers, xhr: true
      expect(response.body).to eq({ errors: 'Not enough or too many segments' }.to_json)
      expect(response.status).to eq(401)
    end

    it 'need admin permission' do
      post products_path, params: { name: name, brand: brand, price: 1000, stock: 10 }.to_json, headers: user_headers, xhr: true
      expect(response.body).to eq({ errors: 'Need admin permission' }.to_json)
      expect(response.status).to eq(401)
    end
  end
end
