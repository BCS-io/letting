require_relative '../../../lib/modules/space_out'

RSpec.describe SpaceOut do
  it 'handles nil' do
    spaced_out = described_class.process(nil)
    expect(spaced_out).to eq ''
  end
  context 'hyphen' do
    it 'spaces out hyphen' do
      spaced_out = described_class.process('100-200')
      expect(spaced_out).to eq '100 - 200'
    end

    it 'leaves hyphen spacing' do
      spaced_out = described_class.process('100 - 200')
      expect(spaced_out).to eq '100 - 200'
    end
  end

  context 'comma' do
    it 'spaces out comma' do
      spaced_out = described_class.process('100,200')
      expect(spaced_out).to eq '100, 200'
    end

    it 'leaves comma spacings' do
      spaced_out = described_class.process('100, 200')
      expect(spaced_out).to eq '100, 200'
    end
  end
end
