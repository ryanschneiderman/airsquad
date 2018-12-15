require 'rails_helper'

RSpec.describe User, type: :model do

  context 'Associations' do
    it 'has_many players' do
      association = described_class.reflect_on_association(:players)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
    it 'has_many coaches' do
      association = described_class.reflect_on_association(:coaches)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
    it 'has_many teams' do
      association = described_class.reflect_on_association(:teams)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end
end