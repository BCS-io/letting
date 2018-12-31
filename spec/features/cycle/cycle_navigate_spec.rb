require 'rails_helper'

RSpec.describe 'Cycle navigate', type: :feature do
  before { log_in admin_attributes }

  describe 'from index page' do
    it 'goes to edit' do
      cycle_create id: 1, name: 'Jan/July', order: 6, cycle_type: 'term'
      visit '/cycles/'

      first(:link, 'Edit').click

      expect(page.title).to eq 'Letting - Edit Cycle'
    end

    it 'goes to delete' do
      cycle_create id: 1, name: 'Jan/July', order: 6, cycle_type: 'term'
      visit '/cycles/'

      expect(page).to have_link 'Delete'
    end
  end

  describe 'from show page' do
    it 'goes to edit' do
      cycle_create id: 3,
                   name: 'Jan',
                   order: 1,
                   cycle_type: 'term',
                   due_ons: [DueOn.new(month: 1, day: 6)]
      visit '/cycles/3'

      click_on 'Edit'

      expect(page.title).to eq 'Letting - Edit Cycle'
    end
  end
end
