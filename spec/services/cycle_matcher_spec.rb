require 'csv'
require 'rails_helper'
require_relative '../../lib/import/file_header'
require_relative '../../lib/import/charges/charge_row'

####
#
# cycle_matcher_spec.rb
#
# unit testing for cycle_matcher
#
####
#
module DB
  describe CycleMatcher, :cycle do
    it 'matches on due_ons' do
      cycle_create id: 6,
                   charged_in: 'advance',
                   due_ons: [DueOn.new(month: 3, day: 25),
                             DueOn.new(month: 9, day: 29)]

      cycmth = CycleMatcher.new charged_in: 'advance',
                                due_on_importables: [DueOnImportable.new(3, 25),
                                                     DueOnImportable.new(9, 29)]
      expect(cycmth.id).to eq 6
    end

    it 'matches on due_ons with show date over cycle with nil show date' do
      cycle_create id: 5,
                   name: 'nil show date',
                   charged_in: 'advance',
                   due_ons: [DueOn.new(month: 3, day: 25),
                             DueOn.new(month: 9, day: 29)]

      cycle_create id: 6,
                   name: 'show date',
                   charged_in: 'advance',
                   due_ons: [DueOn.new(month: 3, day: 25, show_month: 6, show_day: 24),
                             DueOn.new(month: 9, day: 29, show_month: 12, show_day: 25)]

      cycmth = CycleMatcher.new charged_in: 'advance',
                                due_on_importables: [DueOnImportable.new(3, 25, 6, 24),
                                                     DueOnImportable.new(9, 29, 12, 25)]
      expect(cycmth.id).to eq 6
    end

    it 'distinct when due_ons different' do
      cycle_create id: 6,
                   charged_in: 'advance',
                   due_ons: [DueOn.new(month: 3, day: 19)]

      expect do
        CycleMatcher.new(charged_in: 'advance',
                         due_on_importables: [DueOnImportable.new(3, 25)]).id
      end.to raise_error CycleUnknown
    end
  end
end
