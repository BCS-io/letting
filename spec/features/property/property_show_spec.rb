require 'spec_helper'

describe Property do

  it '#shows' do
    property = Property.create id: 1 , human_property_reference: 1000
    property.create_address address_attributes
    property.entities.create person_entity_attributes
    visit '/properties/'
    click_on '1000'
    expect(current_path).to eq '/properties/1'
    expect(page).to have_text '1000'
    expect(page).to have_text '10a'
    expect(page).to have_text 'High Street'
    expect(page).to have_text 'Kingswindford'
    expect(page).to have_text 'Dudley'
    expect(page).to have_text 'West Midlands'
    expect(page).to have_text 'DY6 7RA'

    expect(page).to have_text 'Mr'
    expect(page).to have_text 'X Z'
    expect(page).to have_text 'Ziou'
  end

end