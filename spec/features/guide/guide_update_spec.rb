require 'rails_helper'

describe 'Guide#update', type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  it 'finds data on 1st page and succeeds' do
    invoice_text_create id: 1
    guide_create instruction: 'ins1'
    guide_create fillin: 'Useful'
    guide_create sample: 'Sample'
    visit '/invoice_texts/1/edit'
    expect(page.title). to eq 'Letting - Edit Invoice Text'
    click_on 'Update Invoice Text'
    expect(page).to have_text /updated!/i
  end
end
