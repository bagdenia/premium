require 'rails_helper'

RSpec.describe MovementsController, type: :controller do
  let(:user) { create :user }
  let(:movement) { create(:movement, user: user) }

  subject do
    get :index, params: { user_id: user.id }
    response
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { user_id: user.id }
      expect(subject).to have_http_status(:success)
    end

    it 'returns n entries' do
      get :index, params: { user_id: user.id }
      expect(JSON.parse(subject.body).count).to eq 0
    end
  end
end
