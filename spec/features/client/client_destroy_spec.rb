require 'rails_helper'

RSpec.describe 'Client#destroy', type: :feature do
  before { log_in }

  it '#destroys' do
    client_create
    visit '/clients'
    expect(page).to have_text '354'

    expect { click_on 'Delete' }.to change(Client, :count).by(-1)

    expect(page).to have_text '354'
    expect(page).to have_text 'deleted!'

    expect(page.title).to eq 'Letting - Clients'
  end
end
