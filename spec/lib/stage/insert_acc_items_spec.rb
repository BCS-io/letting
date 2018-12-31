require_relative '../../../lib/stage/insert_acc_items'

RSpec.describe InsertAccItems, :stage do
  def row human_ref: 10,
          charge_type: 'Rent',
          at_time: Date.new(2014, 3, 8),
          value: 4
    { human_ref: human_ref,
      charge_type: charge_type,
      at_time: at_time,
      value: value }
  end

  it 'inserts' do
    input = [row(human_ref: 5,
                 charge_type: 'Rent',
                 at_time: Date.new(2014, 3, 8))]
    insert = InsertAccItems.new \
      insert: [row(human_ref: 10,
                   charge_type: 'Rent',
                   at_time: Date.new(2014, 3, 9))]
    expect(insert.cleanse originals: input)
      .to eq [row(human_ref: 5,
                  charge_type: 'Rent',
                  at_time: Date.new(2014, 3, 8),
                  value: 4),
              row(human_ref: 10,
                  charge_type: 'Rent',
                  at_time: Date.new(2014, 3, 9),
                  value: 4)]
  end
end
