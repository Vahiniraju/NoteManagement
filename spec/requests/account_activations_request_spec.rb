require 'rails_helper'

RSpec.describe 'AccountActivations', type: :request do
  let(:user) { create(:user) }

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_account_activation_url(user.activation_token)
      expect(response).to redirect_to root_path
    end
  end
end
