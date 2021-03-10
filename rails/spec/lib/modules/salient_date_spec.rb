require 'rails_helper'

RSpec.describe SalientDate do
  let(:dummy) { Object.new.extend(described_class) }

  describe '#salient_date_range' do
    it 'outputs date without year when same year' do
      travel_to Date.new(2013, 1, 31) do
        expect(dummy.salient_date_range start_date: Date.parse('2013-04-05'),
                                        end_date: Date.parse('2013-06-07'))
          .to eq '05/Apr - 07/Jun'
      end
    end

    it 'outputs date with year when not this year' do
      expect(dummy.salient_date_range start_date: Date.parse('2015-04-05'),
                                      end_date: Date.parse('2016-06-07'))
        .to eq '05/Apr/15 - 07/Jun/16'
    end

    it 'outputs date with year when different year' do
      expect(dummy.salient_date_range start_date: Date.parse('2013-04-05'),
                                      end_date: Date.parse('2014-06-07'))
        .to eq '05/Apr/13 - 07/Jun/14'
    end

    it 'handles nil start date' do
      expect(dummy.salient_date_range start_date: nil,
                                      end_date: Date.parse('2013-06-07'))
        .to eq ' - 07/Jun/13'
    end

    it 'handles nil end date' do
      expect(dummy.salient_date_range start_date: Date.parse('2013-06-07'),
                                      end_date: nil)
        .to eq '07/Jun/13 - '
    end
  end

  describe '#safe_date' do
    it 'handles nil date' do
      expect(dummy.safe_date date: nil, format: :short).to eq ''
    end

    it 'outputs a present string unchanged' do
      expect(dummy.safe_date date: Date.parse('2014-06-07'), format: :short)
        .to eq '07/Jun/14'
    end
  end
end
