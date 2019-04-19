require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'Associations' do
    it 'belongs_to team' do
      association = described_class.reflect_on_association(:team).macro
      expect(association).to eq :belongs_to
    end
    it 'has_many stats' do
      association = described_class.reflect_on_association(:stats)
      expect(association.macro).to eq :has_many
    end
  end
end
