require 'rails_helper'

RSpec.shared_examples_for Entities do
  describe 'validates' do
    it 'requires entities below the maximum allowed' do
      entityable = described_class.new
      3.times { entityable.entities.build title: 'Mr', name: 'Stuart' }

      expect(entityable).to_not be_valid
    end
  end

  describe '#full_name' do
    it 'creates one name' do
      entityable = described_class.new
      entityable.entities.build title: 'Mr', name: 'Stuart'
      expect(entityable.full_names).to eq 'Mr Stuart'
    end

    it 'joins two names' do
      entityable = described_class.new
      entityable.entities.build title: 'Mr', name: 'Stuart'
      entityable.entities.build title: 'Mr', initials: 'W G', name: 'Grace'
      expect(entityable.full_names).to eq 'Mr Stuart & Mr W. G. Grace'
    end
  end

  context '#prepares_for_form' do
    it 'prepares entities' do
      entityable = described_class.new
      expect(entityable.entities.size).to eq(0)
      entityable.prepare_for_form
      expect(entityable.entities.size).to eq(EntitiesDefaults::MAX_ENTITIES)
    end

    it 'prepares empty entities' do
      entityable = described_class.new
      entityable.prepare_for_form
      expect(entityable.entities).to be_all(&:empty?)
    end

    it 'limits the number of prepared entities' do
      entityable = described_class.new
      entityable.prepare_for_form
      entityable.prepare_for_form
      expect(entityable.entities.size).to eq(EntitiesDefaults::MAX_ENTITIES)
    end

    it '#clear_up_form destroys unused models' do
      entityable = described_class.new
      entityable.prepare_for_form
      entityable.clear_up_form
      expect(entityable.entities.reject(&:marked_for_destruction?).size)
        .to eq(0)
    end
  end
end

RSpec.describe Property do
  it_behaves_like Entities
end

RSpec.describe Agent do
  it_behaves_like Entities
end

RSpec.describe Client do
  it_behaves_like Entities
end
