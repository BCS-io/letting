require 'rails_helper'

RSpec.describe NavigationHelper, type: :helper do
  describe '#main_menu_active?' do
    it 'returns "active" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(main_menu_active? 'accounts').to include 'active-menu'
    end
    it 'returns "inactive" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(main_menu_active? 'accounts').to include 'inactive-menu'
    end
  end
end
