require 'rails_helper'

RSpec.describe Movement::Create do
  include Dry::Monads::Result::Mixin

  let(:user) { create(:user) }
  let(:input) { { user: user, amount: 10, datetime: Time.new('1990-01-01') } }

  subject { described_class.new.call(input) }

  describe 'integration failure' do
    context 'when called with blank input' do
      let(:input) { {} }

      it { is_expected.to be_instance_of(Dry::Monads::Result::Failure) }
    end
  end

  describe 'integration success' do
    context 'when called with valid input' do
      it { is_expected.to be_instance_of(Dry::Monads::Result::Success) }

      it 'changes Movement count' do
        expect { subject }.to change(user.movements, :count).from(0).to(1)
      end
    end
  end

  describe 'steps' do
    context '#validate_input' do
      subject { described_class.new.validate_input(input) }

      context 'input invalid' do
        context 'is nil' do
          let(:input) { { smth: :else } }

          it { is_expected.to be_instance_of(Dry::Monads::Result::Failure) }
        end

        context 'input valid' do
          it { is_expected.to be_instance_of(Dry::Monads::Result::Success) }
        end
      end
    end

    context '#create_movement' do
      subject { described_class.new.create_movement(input) }

      context 'success case' do
        it { is_expected.to be_instance_of(Dry::Monads::Result::Success) }

        it 'changes Movement count' do
          expect { subject }.to change(user.movements, :count).from(0).to(1)
        end
      end

      context 'not enough balance' do
        let(:input) { { user: user, amount: -10, datetime: Time.new('1990-01-01') } }

        it do
          expect { subject }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end
end
