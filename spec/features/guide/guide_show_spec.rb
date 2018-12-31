require 'rails_helper'

RSpec.describe 'Guide#show', type: :feature do
  it 'finds guide data' do
    log_in admin_attributes
    invoice_text_create id: 1
    invoice_text_create id: 2
    guide_create id: 1,
                 instruction: 'ins1',
                 fillin: 'Useful stuff',
                 sample: 'Filled'

    visit '/invoice_texts/2'
    expect(page.title). to eq 'Letting - View Invoice Text'
    expect(page).to have_text 'ins1'
    expect(page).to have_text 'Useful stuff'
    expect(page).to have_text 'Filled'
  end
end
