require 'rails_helper'

RSpec.describe 'Welcomes', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get welcome_index_url
      expect(response).to have_http_status(:success)
    end
  end
end
