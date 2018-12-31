require 'rails_helper'

RSpec.describe SearchSuggestion, type: :model do
  it 'indexes_properties' do
    property_create address: address_new(house_name: 'Box',
                                         road: 'Box',
                                         town: 'Box')
    SearchSuggestion.index_properties
    expect(SearchSuggestion.first.term).to eq 'Box'
    expect(SearchSuggestion.first.popularity).to eq 3
  end

  it 'indexes increments popularity' do
    SearchSuggestion.create! term: 'Bat', popularity: 1
    SearchSuggestion.index_term 'Bat'
    expect(SearchSuggestion.first.popularity).to eq 2
  end

  it 'finds terms' do
    SearchSuggestion.create! term: 'Bat', popularity: 3
    expect(SearchSuggestion.terms_for 'Ba').to eq %w[Bat]
  end

  it 'orders terms by popularity' do
    SearchSuggestion.create! term: 'Bat', popularity: 3
    SearchSuggestion.create! term: 'Baxter', popularity: 5
    expect(SearchSuggestion.terms_for 'Ba').to eq %w[Baxter Bat]
  end
end
