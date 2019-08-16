require 'rails_helper'

RSpec.describe 'Movements', type: :request do
  let(:user) { create :user }

  describe 'GET /user/:id/movements' do
    let!(:user_mvs) { create_list :movement, 3, user: user }
    let!(:other_user_mvs) { create_list :movement, 5 }

    describe 'status of response' do
      subject do
        get(user_movements_path(user.id))
        response
      end

      it { is_expected.to have_http_status(:success) }
    end

    describe 'numbers of users' do
      subject do
        get user_movements_path(user.id)
        JSON.parse(response.body).count
      end

      it { is_expected.to eq(user_mvs.count) }
    end
  end
end
