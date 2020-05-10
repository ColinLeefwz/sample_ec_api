require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe '#login' do
    let(:password) { '123123' }
    let(:user) { create(:user, password: password) }
    let(:token) { 'json token' }
    let(:result) { { token: token }.to_json }
    let(:error) { { error: 'unauthorized' }.to_json }

    it 'sign in successfully' do
      expect(JsonWebToken).to receive(:encode).with(user_id: user.id).and_return(token)
      post login_path, params: { email: user.email, password: password }
      expect(response.body).to eq(result)
      expect(response).to be_successful
    end

    it 'sign in failed' do
      expect(JsonWebToken).not_to receive(:encode)
      post login_path, params: { email: user.email, password: 'wrong' }
      expect(response.body).to eq(error)
      expect(response.status).to eq(401)
    end
  end
end
