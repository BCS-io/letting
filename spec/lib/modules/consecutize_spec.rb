require_relative '../../../lib/modules/consecutize'

RSpec.describe Consecutize do
  it 'initializes one number' do
    consecutive = Consecutize.new(elements: [1])
    expect(consecutive.to_s).to eq '1'
  end

  describe '#add' do
    it 'adds discontinuous then it returns discontinuous' do
      consecutive = Consecutize.new(elements: [1])
      consecutive.add 3
      expect(consecutive.to_s).to eq '1, 3'
    end

    it 'adds continuous then it returns continuous' do
      consecutive = Consecutize.new(elements: [1])
      consecutive.add 2
      expect(consecutive.to_s).to eq '1 - 2'
    end
  end

  it 'returns #merge' do
    consecutive = Consecutize.new(elements: [1])
    consecutive.merge Consecutize.new(elements: [2])
    expect(consecutive.elements).to eq [1, 2]
  end

  describe '#to_s' do
    it 'comma separates discontinuous numbers' do
      consecutive = Consecutize.new(elements: [2, 4])
      expect(consecutive.to_s).to eq '2, 4'
    end

    it 'hyphenates continuous numbers' do
      consecutive = Consecutize.new(elements: [2, 3, 4])
      expect(consecutive.to_s).to eq '2 - 4'
    end

    it 'smoke test continuous and discontinuous numbers' do
      consecutive = Consecutize.new(elements: [2, 4, 5, 6])
      expect(consecutive.to_s).to eq '2, 4 - 6'
    end
  end
end
