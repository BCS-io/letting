
require_relative '../../../lib/modules/rangify'

RSpec.describe Rangify do
  it 'empty string handled' do
    expect { Rangify.from_str('') }.to_not raise_error
  end

  describe 'methods' do
    describe '#to_i' do
      it 'handles single number' do
        expect(Rangify.from_str('103').to_i).to eq 103..103
      end

      it 'handles number range' do
        expect(Rangify.from_str('103-120').to_i).to eq 103..120
      end
    end

    describe '#to_s' do
      it 'handles single number' do
        expect(Rangify.from_str('103').to_s).to eq '103-103'
      end

      it 'handles number range' do
        expect(Rangify.from_str('103-120').to_s).to eq '103-120'
      end
    end
  end
end
