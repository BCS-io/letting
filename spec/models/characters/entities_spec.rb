require 'spec_helper'

shared_examples_for Entities do

  describe '#full_name' do
    it 'creates one name' do
      entityable = described_class.new
      entityable.entities.build title: 'Mr', name: 'Stuart'
      expect(entityable.entities.full_name).to eq 'Mr Stuart'
    end

    it 'joins two names' do
      entityable = described_class.new
      entityable.entities.build title: 'Mr', name: 'Stuart'
      entityable.entities.build title: 'Mr', initials: 'W G', name: 'Grace'
      expect(entityable.entities.full_name).to eq 'Mr Stuart & Mr W. G. Grace'
    end
  end

  context '#prepares_for_form' do
    it 'prepares entities' do
      entityable = described_class.new
      expect(entityable.entities.size).to eq(0)
      entityable.prepare_for_form
      expect(entityable.entities.size).to eq(2)
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
      expect(entityable.entities.size).to eq(2)
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

describe Property do
  it_behaves_like Entities
end

describe Agent do
  it_behaves_like Entities
end

describe Client do
  it_behaves_like Entities
end