require 'rails_helper'

RSpec.describe RevealHelper, type: :helper do
  describe '#hide_empty_records_after_first' do
    it 'display if empty and first' do
      object = double
      allow(object).to receive('empty?').and_return true
      expect(hide_empty_records_after_first record: object, index: 0)
        .to eq ''
    end

    it 'hide if empty and not first' do
      object = double
      allow(object).to receive('empty?').and_return true
      expect(hide_empty_records_after_first(record: object, index: 1))
        .to eq 'js-revealable'
    end

    it 'displays if not empty' do
      object = double
      allow(object).to receive('empty?').and_return false
      expect(hide_empty_records_after_first(record: object, index: 0)).to eq ''
    end
  end

  describe 'hide_or_destroy' do
    it 'return true if first' do
      object = double
      allow(object).to receive('new_record?').and_return true
      expect(hide_or_destroy record: object).to eq 'js-hide-link'
    end

    it 'return false otherwise' do
      object = double
      allow(object).to receive('new_record?').and_return false
      expect(hide_or_destroy record: object).to eq 'js-destroy-link'
    end
  end

  describe 'first_records' do
    it 'return true if first' do
      expect(first_record? index: 0).to eq true
    end
    it 'return false otherwise' do
      expect(first_record? index: 1).to eq false
    end
  end
end
