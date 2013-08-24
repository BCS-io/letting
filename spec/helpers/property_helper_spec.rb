require 'spec_helper'

describe PropertiesHelper do
  describe '#hide_new_record_unless_first' do
    it 'display if new and first' do
      property = Property.new human_id: 1
      property.prepare_for_form
      expect(hide_new_record_unless_first(property.charges.first, 0) ).to be_blank
    end

    it 'hide if new and not first' do
      property = Property.new human_id: 1
      property.prepare_for_form
      expect(hide_new_record_unless_first(property.charges.first, 1) ).to eq 'display: none;'
    end

    it 'displays if valid' do
      property = property_factory_with_charge
      expect(hide_new_record_unless_first property.charges.first,0).to be_blank
    end
  end
end