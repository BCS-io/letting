require 'spec_helper'

describe ApplicationHelper, type: :helper do
  describe '#view_link' do
    it 'disables new records' do
      expect(view_link(property_new)).to include 'disabled'
    end

    it 'enables persisted records' do
      expect(view_link(property_create!)).to_not include 'disabled'
    end
  end
end
