require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  context '/new' do
    it 'returns http success' do
      get login_url
      expect(response).to have_http_status(:success)
    end
  end

  context '/create' do
    let(:user) { create(:user) }
    it 'returns http success' do
      post login_url, params: { session: { user_id: user.id } }
      expect(response).to have_http_status(:success)
    end
  end

  context '/destroy' do
    it 'returns http success' do
      delete logout_url
      expect(response).to have_http_status(:redirect)
    end
  end
end
