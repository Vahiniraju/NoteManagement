require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  let!(:user) { create(:user, reset_digest: 'random') }

  describe 'GET /new' do
    it 'returns http success' do
      get new_password_reset_url
      expect(response).to have_http_status(:success)
    end
  end

  describe '/create' do
    it 'returns http success' do
      post password_resets_url, params: { password_reset: { email: user.email } }
      expect(response).to have_http_status(:redirect)
    end
  end
end
