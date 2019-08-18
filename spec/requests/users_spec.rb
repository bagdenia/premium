require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create :user }

  describe 'GET /users/:id/' do
    describe 'status of response' do
      subject do
        get user_path(user.id)
        response
      end

      it { is_expected.to have_http_status(:success) }
    end

    describe 'response data has expected attrs' do
      let(:expected_keys) do
        %w[id name balance]
      end

      subject do
        get user_path(user.id)
        expected_keys - JSON.parse(response.body).keys
      end

      it { is_expected.to eq [] }
    end
  end

  describe 'GET /users/' do
    let!(:user) { create_list :user, 5 }

    describe 'status of response' do
      subject do
        get users_path
        response
      end

      it { is_expected.to have_http_status(:success) }
    end

    describe 'response data as expected' do
      let(:expected_keys) do
        %w[id name balance]
      end

      subject do
        get users_path
        JSON.parse(response.body)
      end

      it 'has expected keys' do
        res = expected_keys - subject.flat_map(&:keys).uniq
        expect(res).to eq []
      end

      it 'has expected size' do
        expect(subject.count).to eq User.count
      end
    end
  end
end
