require 'rails_helper'

RSpec.describe Team, type: :model do
  context 'Associations' do
    it 'has_many players' do
      association = described_class.reflect_on_association(:players)
      expect(association.macro).to eq :has_many
    end
    it 'has_many coaches' do
      association = described_class.reflect_on_association(:coaches)
      expect(association.macro).to eq :has_many
    end
    it 'has_many games' do
      association = described_class.reflect_on_association(:games)
      expect(association.macro).to eq :has_many
    end
  end
end
