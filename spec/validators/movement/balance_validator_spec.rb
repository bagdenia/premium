require 'rails_helper'

RSpec.describe Movement::BalanceValidator do
  include Dry::Monads::Result::Mixin

  let(:movement) { build(:movement, amount: amount) }
  let!(:previous_movements) do
    create(:movement, user: movement.user, amount: balance)
  end

  let(:balance) { raise 'Define me!' }
  let(:amount) { raise 'Define me!' }

  subject { described_class.new.validate(movement) }

  context 'enough balance' do
    let(:balance) { 100 }
    let(:amount) { -30 }

    it 'generates no errors' do
      expect(subject).to eq nil
    end
  end

  context 'enough balance' do
    let(:balance) { 40 }
    let(:amount) { -100 }

    it 'generates no errors' do
      expect(subject).to eq ['Not enough balance']
    end
  end

  context 'failure during get balance' do
    let(:balance) { 40 }
    let(:amount) { 20 }
    let(:error) { :get_balance_error }

    before do
      allow_any_instance_of(User::GetBalance).to receive(:call).and_return(Failure(error))
    end

    it 'generates no errors' do
      expect(subject).to eq [error.to_s]
    end
  end
end
