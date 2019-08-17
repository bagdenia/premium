require 'rails_helper'

RSpec.describe User::GetBalance do
  include Dry::Monads::Result::Mixin

  let(:user) { create(:user) }
  let(:input) { { user: user } }

  subject { described_class.new.call(input) }

  describe 'integration failure' do
    context 'when called with blank input' do
      let(:input) { {} }

      it { is_expected.to be_instance_of(Dry::Monads::Result::Failure) }
    end
  end

  describe 'steps' do
    context '#validate_input' do
      subject { described_class.new.validate_input(input) }

      context 'when user:' do
        context 'is nil' do
          let(:user) { nil }

          it { is_expected.to be_instance_of(Dry::Monads::Result::Failure) }
        end

        context 'user present' do
          it { is_expected.to be_instance_of(Dry::Monads::Result::Success) }
        end
      end
    end
    # context '#validate_input'

    context '#fetch_balance' do
      subject { described_class.new.fetch_balance(input)[:balance] }

      context 'when has balance for this user' do
        let!(:b1) { create(:balance, user: user) }
        let!(:b2) { create(:balance) }

        it { is_expected.to eq b1 }
      end

      context 'when has not balance for this user' do
        it { is_expected.to be_nil }
      end
    end
    # context '#fetch_balance'

    context '#fetch_new_movements' do
      let!(:m1) { create(:movement, user: user) }
      let!(:m2) { create(:movement, user: user) }
      let!(:m3) { create(:movement) }

      subject { described_class.new.fetch_new_movements(input)[:new_movements] }

      context 'when balance is nil in input' do
        let(:input) { { user: user, balance: nil } }

        it { is_expected.to eq [m1, m2] }
      end

      context 'when has balance in input' do
        let!(:b) { create(:balance, user: user, movement: m1) }
        let(:input) { { user: user, balance: b } }

        context 'when has new movements' do
          let!(:m4) { create(:movement, user: user) }
          let!(:m5) { create(:movement, user: user) }

          it { is_expected.to eq [m2, m4, m5] }
        end

        context 'when has not new movements' do
          it { is_expected.to eq [m2] }
        end
      end
    end
    # context '#fetch_new_movements'

    context '#calculate_balance' do
      subject { described_class.new.calculate_balance(input)[:balance] }

      context 'when has balance in input' do
        let!(:m1) { create(:movement, user: user) }
        let!(:m2) { create(:movement, user: user) }
        let!(:b1) { create(:balance, user: user, movement: m1) }
        let!(:b2) { create(:balance, user: user, movement: m2) }

        context 'when has new_movements in input' do
          let!(:m3) { create(:movement, user: user, amount: 50) }
          let!(:m4) { create(:movement, user: user, amount: -30) }
          let(:input) { { user: user, balance: b2, new_movements: [m3, m4] } }

          it { is_expected.to eq(b2.balance + m3.amount + m4.amount) }
        end

        context 'when has not new_movements in input' do
          let(:input) { { user: user, balance: b2, new_movements: [] } }

          it { is_expected.to eq(b2.balance) }
        end
      end
      # context 'when has balance in input'

      context 'when balance is nil in input' do
        let(:new_b) { Balance.last }

        context 'when has new_movements in input' do
          let!(:m3) { create(:movement, user: user, amount: 50) }
          let!(:m4) { create(:movement, user: user, amount: -30) }
          let(:input) { { user: user, balance: nil, new_movements: [m3, m4] } }

          it { is_expected.to eq(m3.amount + m4.amount) }
        end

        context 'when has not new_movements in input' do
          let(:input) { { user: user, balance: nil, new_movements: [] } }

          it { is_expected.to eq 0 }
        end
      end
      # context 'when balance is nil in input'
    end
    # context '#calculate_balance'

    context '#update_balance' do
      let!(:m) { create(:movement, user: user) }
      let(:balance) { 10_101 }
      let(:new_b) { Balance.last }
      let(:input) { { user: user, balance: balance, new_movements: [m] } }

      subject { described_class.new.update_balance(input) }

      context 'when has new_movements in input' do
        it { is_expected.to eq(Success(balance)) }

        it 'create new Balance' do
          expect { subject }.to change(Balance, :count).by(1)

          expect(new_b.balance).to eq(balance)
          expect(new_b.user).to eq user
          expect(new_b.movement).to eq m
        end
      end

      context 'when has not new_movements in input' do
        let(:input) { { user: user, balance: balance, new_movements: [] } }

        it { is_expected.to eq(Success(balance)) }

        it 'not create new Balance' do
          expect { subject }.to_not change(Balance, :count)
        end
      end

      context 'when balance not saved' do
        let(:error) { 'User::GetBalance error: Balance not created' }

        before do
          allow_any_instance_of(Balance).to receive(:save).and_return(false)
        end

        it { is_expected.to be_instance_of(Dry::Monads::Result::Failure) }
      end
    end
    # context '#update_balance'
  end
end
