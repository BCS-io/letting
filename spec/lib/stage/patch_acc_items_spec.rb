require_relative '../../../lib/stage/patch_acc_info'
require_relative '../../../lib/stage/patch_acc_items'

describe PatchAccItems, :stage do
  def row human_ref: 10,
          charge_type: 'Rent',
          at_time: Date.new(2014, 3, 8),
          value: 4
    { human_ref: human_ref,
      charge_type: charge_type,
      at_time: at_time,
      value: value }
  end

  it 'returns unmatched data unmolested' do
    input = [row(human_ref: 10,
                 charge_type: 'Rent',
                 at_time: Date.new(2014, 3, 8),
                 value: 4)]
    patch = PatchAccItems.new patch: [row(human_ref: 20,
                                          charge_type: 'Rent',
                                          at_time: Date.new(2014, 3, 8),
                                          value: 8)]
    expect(patch.cleanse originals: input)
      .to eq [row(human_ref: 10,
                  charge_type: 'Rent',
                  at_time: Date.new(2014, 3, 8),
                  value: 4)]
  end

  it 'returns patch data when id match' do
    input = [row(human_ref: 10,
                 charge_type: 'Rent',
                 at_time: Date.new(2014, 3, 8),
                 value: 4)]
    patch = PatchAccItems.new \
      patch: [row(human_ref: 10,
                  charge_type: 'Rent',
                  at_time: Date.new(2014, 3, 8),
                  value: 8)]
    expect(patch.cleanse originals: input)
      .to eq [row(human_ref: 10,
                  charge_type: 'Rent',
                  at_time: Date.new(2014, 3, 8),
                  value: 8)]
  end
end
