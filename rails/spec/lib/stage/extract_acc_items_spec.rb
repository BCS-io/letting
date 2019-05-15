require_relative '../../../lib/stage/extract_acc_items'

RSpec.describe ExtractAccItems, :stage do
  def row human_ref: 10,
          charge_code: 'GR',
          at_time: Date.new(2014, 3, 8),
          value: 4
    { human_ref: human_ref,
      charge_code: charge_code,
      at_time: at_time,
      value: value }
  end

  it 'does not delete when different' do
    input = [row(human_ref: 10,
                 charge_code: 'GR',
                 at_time: Date.new(2014, 3, 8),
                 value: 4)]
    extract = ExtractAccItems.new \
      extracts: [row(human_ref: 20,
                     charge_code: 'GR',
                     at_time: Date.new(2014, 3, 8),
                     value: 8)]
    extract.cleanse originals: input
    expect(input).to eq [row(human_ref: 10,
                             charge_code: 'GR',
                             at_time: Date.new(2014, 3, 8),
                             value: 4)]
  end

  it 'deletes when id match' do
    input = [row(human_ref: 10,
                 charge_code: 'GR',
                 at_time: Date.new(2014, 3, 8),
                 value: 4)]
    extract = ExtractAccItems.new \
      extracts: [row(human_ref: 10,
                     charge_code: 'GR',
                     at_time: Date.new(2014, 3, 8),
                     value: 8)]
    extract.cleanse originals: input
    expect(input).to eq []
  end
end
