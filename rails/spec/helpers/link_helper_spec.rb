require 'rails_helper'

RSpec.describe LinkHelper, type: :helper do
  describe '#view_link' do
    it 'disables new records' do
      expect(view_link(property_new)).to include 'disabled'
    end

    it 'enables persisted records' do
      expect(view_link(property_create)).not_to include 'disabled'
    end
  end
end
