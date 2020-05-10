require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:password) { '123123' }
  let(:user) { create(:user, password: password) }
  let(:product_1) { create(:product, price: 1200, stock: 100) }
  let(:product_2) { create(:product, price: 1200, stock: 100) }
  let!(:order_1) { create(:order, user: user, product: product_1) }
  let!(:order_2) { create(:order, user: user, product: product_2) }
  let(:admin) { create(:user, :admin) }
  let(:auth) { JsonWebToken.encode(user_id: admin.id) }
  let(:user_auth) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => auth } }
  let(:user_headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => user_auth } }
  let(:wrong_headers) { { "CONTENT_TYPE" => "application/json", "Authorization" => "wrong_token" } }

  describe '#create' do
    let(:name) { 'username' }
    let(:email) { 'username@gmail.com' }
    let(:result) {
      {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      }
    }

    it 'create user successfully' do
      expect(User).to receive(:create!).and_return(user)
      post users_path, params: { name: name, email: email, password: password }.to_json, headers: headers, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'no auth header' do
      post users_path, params: { name: name, email: email, password: password }.to_json, xhr: true
      expect(response.body).to eq({ errors: 'Nil JSON web token' }.to_json)
      expect(response.status).to eq(401)
    end

    it 'wrong auth token' do
      post users_path, params: { name: name, email: email, password: password }.to_json, headers: wrong_headers, xhr: true
      expect(response.body).to eq({ errors: 'Not enough or too many segments' }.to_json)
      expect(response.status).to eq(401)
    end

    it 'need admin permission' do
      post users_path, params: { name: name, email: email, password: password }.to_json, headers: user_headers, xhr: true
      expect(response.body).to eq({ errors: 'Need admin permission' }.to_json)
      expect(response.status).to eq(401)
    end
  end

  describe '#find' do
    let(:result) {
      {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        last_purchased_date: user.last_purchase_date,
      }
    }
    let(:not_found_result) {
      {
        error: 'not_found',
      }
    }

    it 'is successful' do
      get users_find_path, params: { email: user.email }, headers: headers, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'not found' do
      get users_find_path, params: { email: 'not_found' }, headers: headers, xhr: true
      expect(response.body).to eq(not_found_result.to_json)
      expect(response.status).to eq(404)
    end

    it 'need admin permission' do
      get users_find_path, params: { email: user.email }, headers: user_headers, xhr: true
      expect(response.body).to eq({ errors: 'Need admin permission' }.to_json)
      expect(response.status).to eq(401)
    end
  end

  describe '#me' do
    let(:result) {
      {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        last_purchased_date: user.last_purchase_date,
        customer_rank: user.customer_rank,
      }
    }

    it 'is successful' do
      get users_me_path, headers: user_headers, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'not found' do
      get users_me_path, headers: wrong_headers, xhr: true
      expect(response.body).to eq({ errors: 'Not enough or too many segments' }.to_json)
      expect(response.status).to eq(401)
    end
  end

  describe '#products_list' do
    let(:result) {
      [
        {
          product_id: order_1.product_id,
          name: order_1.product_name,
          brand: order_1.product_brand,
          purchased_date: order_1.ready_at,
        },
        {
          product_id: order_2.product_id,
          name: order_2.product_name,
          brand: order_2.product_brand,
          purchased_date: order_2.ready_at,
        },
      ]
    }

    it 'is successful' do
      get users_me_products_path, headers: user_headers, xhr: true
      expect(response.body).to eq(result.to_json)
      expect(response).to be_successful
    end

    it 'not found' do
      get users_me_products_path, headers: wrong_headers, xhr: true
      expect(response.body).to eq({ errors: 'Not enough or too many segments' }.to_json)
      expect(response.status).to eq(401)
    end
  end
end
