require 'rails_helper'

RSpec.describe CycleDecorator do
  it 'returns cycles' do
    cycle_create id: 1, name: 'Year', due_ons: [DueOn.new(month: 3, day: 2)]
    cycle_create id: 2, name: 'Half', due_ons: [DueOn.new(month: 1, day: 1),
                                                DueOn.new(month: 3, day: 2)]
    cycle_create id: 3, name: 'Quart', due_ons: [DueOn.new(month: 1, day: 1),
                                                 DueOn.new(month: 3, day: 1),
                                                 DueOn.new(month: 6, day: 1),
                                                 DueOn.new(month: 9, day: 1)]

    cycle_create id: 4, name: 'Freq', due_ons: [DueOn.new(month: 1, day: 1),
                                                DueOn.new(month: 3, day: 1),
                                                DueOn.new(month: 6, day: 1),
                                                DueOn.new(month: 8, day: 1),
                                                DueOn.new(month: 9, day: 1)]
    expect(CycleDecorator.for_select).to eq 'Frequent' => [['Freq', 4]],
                                            'Half Year' => [['Half', 2]],
                                            'Quarterly' => [['Quart', 3]],
                                            'Year' => [['Year', 1]]
  end

  it 'orders' do
    cycle_create id: 1,
                 name: 'Mar',
                 order: 2,
                 due_ons: [DueOn.new(month: 3, day: 2)]
    cycle_create id: 2,
                 name: 'Sep',
                 order: 1,
                 due_ons: [DueOn.new(month: 9, day: 2)]
    expect(CycleDecorator.for_select).to eq 'Frequent' => [],
                                            'Half Year' => [],
                                            'Quarterly' => [],
                                            'Year' => [['Sep', 2], ['Mar', 1]]
  end
end
