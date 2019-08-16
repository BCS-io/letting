require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe Cycle, :ledgers, :range, :cycle, type: :model do
  describe 'validates' do
    it('returns valid') { expect(cycle_new).to be_valid }
    it('requires a name') { expect(cycle_new name: '').not_to be_valid }
    it('charged_in') { expect(cycle_new charged_in: nil).not_to be_valid }
    it('requires an order') { expect(cycle_new order: '').not_to be_valid }
    it 'requires a cycle_type' do
      (cycle = cycle_new).cycle_type = ''
      expect(cycle).not_to be_valid
    end
    it 'includes cycle_type of term' do
      (cycle = cycle_new).cycle_type = 'term'
      expect(cycle).to be_valid
    end
    it 'includes cycle_type of monthly' do
      (cycle = cycle_new).cycle_type = 'monthly'
      expect(cycle).to be_valid
    end
    it 'no other cycle_type accepted' do
      (cycle = cycle_new).cycle_type = 'anything'
      expect(cycle).not_to be_valid
    end
  end

  describe '#monthly?' do
    it 'is monthly when initialized monthly' do
      expect(cycle_new(cycle_type: 'monthly', prepare: true)).to be_monthly
    end

    it 'is not monthly when initialized term' do
      expect(cycle_new(cycle_type: 'term', prepare: true)).not_to be_monthly
    end
  end

  describe '#between' do
    it 'returns the date of the matching due_on' do
      cycle = cycle_new due_ons: [DueOn.new(month: 1, day: 1)]
      expect(cycle.between(Date.new(1980, 1, 1)..Date.new(1980, 1, 2)))
        .to eq [MatchedCycle.new(Date.new(1980, 1, 1),
                                 Date.new(1980, 1, 1)..Date.new(1980, 12, 31))]
    end

    it 'returns nothing on mismatching due_on' do
      cycle = cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

      expect(cycle.between Date.new(1980, 2, 1)..Date.new(1980, 3, 4)).to eq []
    end

    it 'returns the dates of all the matching due_ons' do
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 4),
                                  DueOn.new(month: 9, day: 5)]

      expect(cycle.between Date.new(2010, 3, 1)..Date.new(2011, 2, 28))
        .to eq [MatchedCycle.new(Date.new(2010, 3, 4),
                                 Date.new(2010, 3, 4)..Date.new(2010, 9, 4)),
                MatchedCycle.new(Date.new(2010, 9, 5),
                                 Date.new(2010, 9, 5)..Date.new(2011, 3, 3))]
    end

    it 'returns a due_on date for each matching year' do
      cycle = cycle_new due_ons: [DueOn.new(month: 3, day: 5)]

      expect(cycle.between Date.new(2010, 3, 1)..Date.new(2012, 3, 6))
        .to eq [MatchedCycle.new(Date.new(2010, 3, 5),
                                 Date.new(2010, 3, 5)..Date.new(2011, 3, 4)),
                MatchedCycle.new(Date.new(2011, 3, 5),
                                 Date.new(2011, 3, 5)..Date.new(2012, 3, 4)),
                MatchedCycle.new(Date.new(2012, 3, 5),
                                 Date.new(2012, 3, 5)..Date.new(2013, 3, 4))]
    end
  end

  describe '#billed_period' do
    describe 'bounding' do
      it 'matches when billed_on is at start of bill_period' do
        cycle = cycle_new charged_in: 'advance',
                          due_ons: [DueOn.new(month: 3, day: 5)]

        expect(cycle.bill_period billed_on: Date.new(2000, 3, 5))
          .to eq Date.new(2000, 3, 5)..Date.new(2001, 3, 4)
      end

      it 'matches when billed_on is within bill_period' do
        cycle = cycle_new charged_in: 'advance',
                          due_ons: [DueOn.new(month: 3, day: 5)]

        expect(cycle.bill_period billed_on: Date.new(2000, 12, 12))
          .to eq Date.new(2000, 3, 5)..Date.new(2001, 3, 4)
      end

      # THIS FAILS to match as the billed_on date leads to creation of 2001
      # dates (in cycle.show_dates) when only 2000 dates would match.
      #
      # When we get a billed_on we need to get the year at the start of the
      # range not the year of the date passed into method.
      #
      # This requirement would only be useful for importing balance row
      # charges so for now it is left as an optional requirement.
      #
      # it 'matches when billed_on is at end of bill_period' do
      #   skip 'TODO: fix this'
      #   cycle = cycle_new charged_in: 'advance',
      #                     due_ons: [DueOn.new(month: 3, day: 5)]

      #   expect(cycle.bill_period billed_on: Date.new(2001, 3, 4))
      #     .to eq Date.new(2000, 3, 5)..Date.new(2001, 3, 4)
      # end
    end

    it 'displays show range when present' do
      due_on = DueOn.new month: 3, day: 5, show_month: 4, show_day: 10
      cycle = cycle_new charged_in: 'advance',
                        due_ons: [due_on]

      expect(cycle.bill_period billed_on: Date.new(2000, 4, 10))
        .to eq Date.new(2000, 4, 10)..Date.new(2001, 4, 9)
    end

    it 'errors when show range present and billed_on past due_date ' do
      due_on = DueOn.new month: 3, day: 5, show_month: 4, show_day: 10
      cycle = cycle_new due_ons: [due_on]
      expect(cycle.bill_period billed_on: Date.new(2000, 3, 5))
        .to eq :missing_due_on
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      cycle = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 3, day: 25)]
      other = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 3, day: 25)]
      expect(cycle <=> other).to eq 0
    end

    it 'equality is order independent' do
      cycle = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 1, day: 1),
                                                                   DueOn.new(month: 6, day: 6)]

      other = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6),
                                                                   DueOn.new(month: 1, day: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'ignores cycle name in matching' do
      cycle = cycle_new name: 'Mar/Sep', due_ons: [DueOn.new(month: 1, day: 1)]
      other = cycle_new name: 'Jan/Dec', due_ons: [DueOn.new(month: 1, day: 1)]
      expect(cycle <=> other).to eq 0
    end

    it 'uses charged_id in matching' do
      cycle = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 1, day: 1)]
      other = described_class.new charged_in: 'arrears', due_ons: [DueOn.new(month: 1, day: 1)]
      expect(cycle <=> other).to eq(-1)
    end

    it 'returns 1 when lhs > rhs for due_ons' do
      lhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6)]
      rhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 1, day: 1)]
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns 1 when lhs > rhs for charged_in' do
      lhs = described_class.new charged_in: 'arrears', due_ons: [DueOn.new(month: 6, day: 6)]
      rhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6)]
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      lhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 1, day: 1)]
      rhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6)]
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns -1 when lhs < rhs for charged_in' do
      lhs = described_class.new charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6)]
      rhs = described_class.new charged_in: 'arrears', due_ons: [DueOn.new(month: 6, day: 6)]
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(described_class.new(charged_in: 'advance', due_ons: [DueOn.new(month: 6, day: 6)]) <=> 37).to be_nil
    end
  end

  describe 'form preparation' do
    context 'when term' do
      it '#prepare creates children' do
        cycle = cycle_new cycle_type: 'term', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(4)
      end

      it '#clear_up_form destroys children' do
        cycle = cycle_new cycle_type: 'term',
                          due_ons: [DueOn.new(month: 3, day: 25)]
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons.reject(&:marked_for_destruction?).size).to eq(1)
      end
    end

    context 'when monthly' do
      it '#prepare creates children' do
        cycle = cycle_new cycle_type: 'monthly', due_ons: nil
        expect(cycle.due_ons.size).to eq(0)
        cycle.prepare
        expect(cycle.due_ons.size).to eq(12)
      end

      it '#clear_up_form keeps children if day set' do
        cycle = cycle_new cycle_type: 'monthly', due_ons: nil
        cycle.prepare
        cycle.valid?
        expect(cycle.due_ons.reject(&:marked_for_destruction?).size).to eq(0)
      end
    end
  end

  describe '#to_s' do
    it 'displays' do
      expect(cycle_new.to_s)
        .to eq 'cycle: Mar, type: term, charged_in: advance, due_ons: [Mar 25]'
    end
  end
end
