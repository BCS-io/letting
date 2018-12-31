require_relative '../../../lib/stage/patch_acc_info'

RSpec.describe PatchAccInfo, :stage do
  def row human_ref: 10, charge_type: 'Rent', value: 4
    { human_ref: human_ref, charge_type: charge_type, value: value }
  end

  it 'returns unmatched data unmolested' do
    input = [row(human_ref: 10, charge_type: 'Rent', value: 4)]
    patch = PatchAccInfo.new \
      patch: [row(human_ref: 20, charge_type: 'Rent', value: 8)]
    expect(patch.cleanse originals: input)
      .to eq [row(human_ref: 10, charge_type: 'Rent', value: 4)]
  end

  it 'returns patch data when id match' do
    input = [row(human_ref: 10, charge_type: 'Rent', value: 4)]
    patch = PatchAccInfo.new \
      patch: [row(human_ref: 10, charge_type: 'Rent', value: 8)]
    expect(patch.cleanse originals: input)
      .to eq [row(human_ref: 10, charge_type: 'Rent', value: 8)]
  end
end
