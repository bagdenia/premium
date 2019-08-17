require 'rails_helper'

RSpec.describe Movement, type: :model do
  context 'check triggers working' do
    let!(:movement) { create :movement }

    subject { movement.delete }

    it { expect { subject }.to raise_error(ActiveRecord::StatementInvalid) }
  end

  context 'custom validators' do
    it 'uses custom validator BalanceValidator' do
      described_class.validators.find do |v|
        v.class == Movement::BalanceValidator
      end
    end
  end
end
