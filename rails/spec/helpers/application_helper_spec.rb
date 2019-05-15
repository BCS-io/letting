require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_empty_string_as_dash' do
    it 'adds a dash when string empty' do
      expect(format_empty_string_as_dash('')).to eq '-'
    end

    it 'outputs a present string unchanged' do
      expect(format_empty_string_as_dash('Test')).to eq 'Test'
    end
  end
end
