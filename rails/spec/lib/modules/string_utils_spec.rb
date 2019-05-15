require 'rails_helper'
require_relative '../../../lib/modules/string_utils'

# Test Dummy for this spec
class StringTest
  include StringUtils
end

RSpec.describe StringUtils do
  describe 'is_num?' do
    it 'return true if a numeric' do
      expect(StringTest.num?('10')).to eq true
    end

    it 'return false if a none-numeric' do
      expect(StringTest.num?('something')).to eq false
    end

    # Ruby to_i would convert '10 Downton' => 10
    it 'return false if contains a number and a string' do
      expect(StringTest.num?('10 something')).to eq false
    end
  end
end
