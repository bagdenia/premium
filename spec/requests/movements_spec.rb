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

  describe 'POST /user/:id/movements' do
    let(:amount) { 50 }
    let(:datetime) { Time.now }

    let(:request_params) do
      {
        params: {
          data: {
            type: 'movements',
            attributes: {
              amount: amount,
              datetime: datetime
            }
          }
        }
      }
    end

    subject do
      post user_movements_path(user.id), request_params
      response
    end

    let(:response_body) do
      post user_movements_path(user.id), request_params
      JSON.parse(response.body)
    end

    context 'valid' do
      describe 'status of response' do
        it { is_expected.to have_http_status(:created) }
      end

      describe 'result' do
        it do
          expect { subject }.to change(user.movements, :count).by(1)
        end
      end
    end

    context 'when not enough balance' do
      let(:amount) { -5 }

      describe 'status of response' do
        it { is_expected.to have_http_status(:internal_server_error) }
      end

      describe 'result' do
        it do
          expect { subject }.not_to change(user.movements, :count)
        end

        it do
          expect(response_body['message']).to eq 'Validation failed: Not enough balance'
        end
      end
    end

    context 'when datatime is nil' do
      let(:datetime) { nil }

      describe 'status of response' do
        it { is_expected.to have_http_status(:bad_request) }
      end

      describe 'result' do
        it do
          expect { subject }.not_to change(user.movements, :count)
        end

        it do
          expect(response_body['error']).to eq 'parameter_missing'
        end
      end
    end

    context 'when datatime is absent' do
      let(:request_params) do
        {
          params: {
            data: {
              type: 'movements',
              attributes: {
                amount: amount
              }
            }
          }
        }
      end

      describe 'status of response' do
        it { is_expected.to have_http_status(:bad_request) }
      end

      describe 'result' do
        it do
          expect { subject }.not_to change(user.movements, :count)
        end

        it do
          expect(response_body['error']).to eq 'parameter_missing'
        end
      end
    end

    context 'when datatime is wrong format' do
      let(:datetime) { 'wtf' }

      describe 'status of response' do
        it { is_expected.to have_http_status(:bad_request) }
      end

      describe 'result' do
        it do
          expect { subject }.not_to change(user.movements, :count)
        end

        it do
          expect(response_body['error']).to eq 'Invalid datetime format'
        end
      end
    end

    context 'when amount is absent' do
      let(:request_params) do
        {
          params: {
            data: {
              type: 'movements',
              attributes: {
                datetime: datetime
              }
            }
          }
        }
      end

      describe 'status of response' do
        it { is_expected.to have_http_status(:bad_request) }
      end

      describe 'result' do
        it do
          expect { subject }.not_to change(user.movements, :count)
        end

        it do
          expect(response_body['error']).to eq 'parameter_missing'
        end
      end
    end
  end
end
