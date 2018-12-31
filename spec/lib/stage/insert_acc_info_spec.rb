require_relative '../../../lib/stage/insert_acc_info'

RSpec.describe InsertAccInfo, :stage do
  def row human_ref: 10, charge_type: 'Rent', value: 4
    { human_ref: human_ref, charge_type: charge_type, value: value }
  end

  it 'inserts' do
    input = [row(human_ref: 5, charge_type: 'Rent', value: 1)]
    insert = InsertAccInfo.new \
      insert: [row(human_ref: 10, charge_type: 'Rent', value: 2)]
    expect(insert.cleanse originals: input)
      .to eq [row(human_ref: 5, charge_type: 'Rent', value: 1),
              row(human_ref: 10, charge_type: 'Rent', value: 2)]
  end

  describe 'sort' do
    it 'sorts on human_ref' do
      input = [row(human_ref: 10, charge_type: 'Rent'),
               row(human_ref: 1, charge_type: 'Rent')]
      insert = InsertAccInfo.new \
        insert: [row(human_ref: 5, charge_type: 'Rent')]
      insert.cleanse originals: input
      expect(input).to eq [row(human_ref: 1, charge_type: 'Rent'),
                           row(human_ref: 5, charge_type: 'Rent'),
                           row(human_ref: 10, charge_type: 'Rent')]
    end

    it 'sorts on charge_type' do
      input = [row(human_ref: 1, charge_type: 'Rent'),
               row(human_ref: 1, charge_type: 'Vent')]
      insert = InsertAccInfo.new \
        insert: [row(human_ref: 1, charge_type: 'Sent')]
      expect(insert.cleanse originals: input)
        .to eq [row(human_ref: 1, charge_type: 'Rent'),
                row(human_ref: 1, charge_type: 'Sent'),
                row(human_ref: 1, charge_type: 'Vent')]
    end

    it 'primary sort human_ref secondary sort charge_type' do
      input = [row(human_ref: 1, charge_type: 'Vent'),
               row(human_ref: 2, charge_type: 'Sent')]
      insert = InsertAccInfo.new \
        insert: [row(human_ref: 3, charge_type: 'Rent')]
      expect(insert.cleanse originals: input)
        .to eq [row(human_ref: 1, charge_type: 'Vent'),
                row(human_ref: 2, charge_type: 'Sent'),
                row(human_ref: 3, charge_type: 'Rent')]
    end
  end
end
