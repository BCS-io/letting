require 'rails_helper'

RSpec.describe 'InvoiceText#index', type: :system do
  before(:each) do
    log_in admin_attributes
  end

  it 'basic' do
    invoice_text_create id: 2, description: 'Page 2'
    visit '/invoice_texts/'

    expect(page).to have_title 'Letting - Invoice Texts'
    expect(page).to have_text 'Page 2'
  end

  it 'has edit link' do
    invoice_text_create
    visit '/invoice_texts/'

    click_on 'Edit'
    expect(page.title).to eq 'Letting - Edit Invoice Text'
  end

  it 'has view link on icon' do
    invoice_text_create
    visit '/invoice_texts/'

    first('.link-view-testing', visible: false).click
    expect(page.title).to eq 'Letting - View Invoice Text'
  end

  it 'has ordered list' do
    invoice_text_create id: 1, invoice_name: 'Morgan'
    visit '/invoice_texts/'

    first(:link, 'Edit').click
    expect(page).to have_text 'Page 1'
    expect(find_field('Company Name').value).to have_text 'Morgan'
  end
end
