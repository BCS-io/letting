require 'rails_helper'

RSpec.describe AccountFinder, type: :model do
  it 'finds a property in range' do
    account_create property: property_new(human_ref: 8)

    find = AccountFinder.new property_range: '8-8'
    expect(find.matching.size).to eq 1
  end

  it 'does not find a property out of range' do
    account_create property: property_new(human_ref: 600)

    find = AccountFinder.new property_range: '8-8'
    expect(find.matching.size).to eq 0
  end
end
