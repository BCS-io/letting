require 'rails_helper'

RSpec.describe SearchSuggestion, type: :model do
  it 'indexes_properties' do
    property_create address: address_new(house_name: 'Box',
                                         road: 'Box',
                                         town: 'Box')
    described_class.index_properties
    expect(described_class.first.term).to eq 'Box'
    expect(described_class.first.popularity).to eq 3
  end

  it 'indexes increments popularity' do
    described_class.create! term: 'Bat', popularity: 1
    described_class.index_term 'Bat'
    expect(described_class.first.popularity).to eq 2
  end

  it 'finds terms' do
    described_class.create! term: 'Bat', popularity: 3
    expect(described_class.terms_for 'Ba').to eq %w[Bat]
  end

  it 'orders terms by popularity' do
    described_class.create! term: 'Bat', popularity: 3
    described_class.create! term: 'Baxter', popularity: 5
    expect(described_class.terms_for 'Ba').to eq %w[Baxter Bat]
  end
end
