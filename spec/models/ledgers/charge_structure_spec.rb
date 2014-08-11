require 'rails_helper'

RSpec.describe ChargeStructure, type: :model do
  let(:structure) do
    structure = ChargeStructure.new charge_cycle_id: 1
    structure.build_charged_in id: 1, name: 'Advance'
    structure.due_ons.new due_on_attributes_0 charge_structure_id: 1
    structure
  end

  it 'returns referenced attribute as string' do
    expect(structure.charged_in_name).to be_kind_of(String)
  end

  describe '#due_dates' do
    before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
    after(:each)  { Timecop.return }

    it 'creates charging date if in range'  do
      expect(structure.due_dates(Date.new(2013, 3, 25)..Date.new(2013, 3, 25)))
        .to eq [Date.new(2013, 3, 25)]
    end
  end

  describe 'due_ons' do
    it 'due_ons' do
      structure.due_ons.destroy_all
      expect(structure).to_not be_valid
    end

    it '#prepare creates children' do
      structure.prepare
      expect(structure.due_ons.size).to eq(4)
    end

    it '#clear_up_form destroys children' do
      structure.clear_up_form
      expect(structure.due_ons.size).to eq(1)
    end
  end
end
