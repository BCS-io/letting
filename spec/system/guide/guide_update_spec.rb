require 'rails_helper'

RSpec.describe 'Guide#update', type: :system do
  before(:each) do
    log_in admin_attributes
  end

  it 'finds data on 1st page and succeeds' do
    invoice_text = invoice_text_create id: 1
    guide_create instruction: 'ins1', invoice_text: invoice_text
    guide_create fillin: 'Useful', invoice_text: invoice_text
    guide_create sample: 'Sample', invoice_text: invoice_text
    visit '/invoice_texts/1/edit'
    expect(page.title). to eq 'Letting - Edit Invoice Text'
    click_on 'Update Invoice Text'
    expect(page).to have_text /updated!/i
  end
end
