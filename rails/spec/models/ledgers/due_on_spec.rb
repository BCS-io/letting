require 'rails_helper'

# rubocop: disable Lint/UselessComparison

RSpec.describe DueOn, :ledgers, :cycle, type: :model do
  it('is valid') { expect(due_on_new).to be_valid }

  describe 'Attribute' do
    describe 'day' do
      it('is required')   { expect(due_on_new day: nil).not_to be_valid }
      it('is numeric')    { expect(due_on_new day: 'ab').not_to be_valid }
      it('is an integer') { expect(due_on_new day: 8.3).not_to be_valid }
      it('is > 0')        { expect(due_on_new day: 0).not_to be_valid }
      it('is < 32')       { expect(due_on_new day: 32).not_to be_valid }
    end

    describe 'month' do
      it('is required')   { expect(due_on_new month: nil).not_to be_valid }
      it('is numeric')    { expect(due_on_new month: 'ab').not_to be_valid }
      it('is an integer') { expect(due_on_new month: 8.3).not_to be_valid }
      it('is > -1') { expect(due_on_new month: -2).not_to be_valid }
      it('is < 13')       { expect(due_on_new month: 13).not_to be_valid }
    end

    describe 'year' do
      it('is numeric')    { expect(due_on_new year: 'ab').not_to be_valid }
      it('is an integer') { expect(due_on_new year: 8.3).not_to be_valid }
      it('is >= 1990')    { expect(due_on_new year: 1989).not_to be_valid }
      it('is < 2030')     { expect(due_on_new year: 2030).not_to be_valid }
    end

    describe 'show month' do
      it 'is required' do
        expect(due_on_new show_month: nil, show_day: 1).not_to be_valid
      end

      it('is numeric')    { expect(due_on_new show_month: 'a').not_to be_valid }
      it('is an integer') { expect(due_on_new show_month: 8.3).not_to be_valid }
      it('is > -1')       { expect(due_on_new show_month: -2).not_to be_valid }
      it('is < 13')       { expect(due_on_new show_month: 13).not_to be_valid }
    end

    describe 'show_day' do
      it 'is required' do
        expect(due_on_new show_month: 1, show_day: nil).not_to be_valid
      end

      it('is numeric')    { expect(due_on_new show_day: 'a').not_to be_valid }
      it('is an integer') { expect(due_on_new show_day: 8.3).not_to be_valid }
      it('is > 0')        { expect(due_on_new show_day: 0).not_to be_valid }
      it('is < 32')       { expect(due_on_new show_day: 32).not_to be_valid }
    end
  end

  describe 'methods' do
    describe '#between' do
      it 'returns the MatchedDueOn when date within spot_date range' do
        expect(due_on_new(month: 3, day: 25)
          .between Date.new(2013, 3, 25)..Date.new(2013, 3, 25))
          .to eq [MatchedDueOn.new(Date.new(2013, 3, 25), Date.new(2013, 3, 25))]
      end

      it 'handles date time argument' do
        expect(due_on_new(month: 3, day: 25)
          .between Time.zone.local(2007, 8, 17, 11, 56, 0)..
                   Time.zone.local(2008, 8, 16, 11, 56, 0))
          .to eq [MatchedDueOn.new(Date.new(2008, 3, 25), Date.new(2008, 3, 25))]
      end

      it 'handles multi-year argument' do
        expect(due_on_new(month: 3, day: 5)
          .between Date.new(2010, 3, 1)..Date.new(2012, 3, 6))
          .to eq [MatchedDueOn.new(Date.new(2010, 3, 5), Date.new(2010, 3, 5)),
                  MatchedDueOn.new(Date.new(2011, 3, 5), Date.new(2011, 3, 5)),
                  MatchedDueOn.new(Date.new(2012, 3, 5), Date.new(2012, 3, 5))]
      end

      it 'returns empty array when date outside spot_date range' do
        expect(due_on_new(month: 1, day: 1)
          .between Date.new(2013, 3, 25)..Date.new(2013, 3, 25)).to eq []
      end
    end

    describe '#show_date' do
      it 'displays show_date if present' do
        expect(due_on_new(show_month: 9, show_day: 1).show_date(year: 1980))
          .to eq Date.new 1980, 9, 1
      end

      it 'displays on_date if no display date' do
        expect(due_on_new(month: 3, day: 25).show_date(year: 1980))
          .to eq Date.new 1980, 3, 25
      end
    end

    describe '#show' do
      it 'displays true when show dates' do
        expect(due_on_new(month: 3, day: 25, show_month: 2, show_day: 3))
          .to be_show
      end

      it 'displays true when show_month set' do
        expect(due_on_new(month: 3, day: 25, show_month: 2, show_day: nil))
          .to be_show
      end

      it 'displays true when show_day set' do
        expect(due_on_new(month: 3, day: 25, show_month: nil, show_day: 2))
          .to be_show
      end

      it 'returns false when no show dates' do
        expect(due_on_new(month: 3, day: 25, show_month: nil, show_day: nil))
          .not_to be_show
      end
    end

    describe '#clear_up_form' do
      context 'when new' do
        it 'saveable when valid' do
          due_on = due_on_new day: 1, month: nil
          due_on.clear_up_form
          expect(due_on).not_to be_marked_for_destruction
        end

        it 'destroyed when invalid' do
          due_on = due_on_new day: nil, month: nil
          due_on.clear_up_form
          expect(due_on).to be_marked_for_destruction
        end
      end
    end

    # public as it is called by due_ons.empty?
    describe '#empty?' do
      it 'with attributes not empty' do
        expect(due_on_new month: 3, day: 25).not_to be_empty
      end

      it 'without attributes empty' do
        expect(due_on_new day: nil, month: nil).to be_empty
      end
    end

    describe '#<=>' do
      it 'returns 0 when equal and no display date' do
        expect(due_on_new(month: 2, day: 2, show_month: nil, show_day: nil) <=>
          due_on_new(month: 2, day: 2, show_month: nil, show_day: nil)).to eq(0)
      end

      it 'returns 0 when equal and display dates' do
        expect(due_on_new(month: 2, day: 2, show_month: 4, show_day: 5) <=>
          due_on_new(month: 2, day: 2, show_month: 4, show_day: 5)).to eq(0)
      end

      it 'differs when due_dates equal and display dates different' do
        expect(due_on_new(month: 2, day: 2, show_month: nil, show_day: nil) <=>
          due_on_new(month: 2, day: 2, show_month: 4, show_day: 5)).not_to eq(0)
      end

      it 'returns 1 when lhs > rhs and no display date' do
        expect(due_on_new(month: 2, day: 2) <=>
          due_on_new(month: 1, day: 2)).to eq(1)
      end

      it 'returns 1 when lhs > rhs and display date' do
        expect(due_on_new(month: 2, day: 2, show_month: 4, show_day: 2) <=>
          due_on_new(month: 1, day: 2)).to eq(1)
      end

      it 'returns -1 when lhs < rhs' do
        expect(due_on_new(month: 2, day: 2) <=>
          due_on_new(month: 3, day: 2)).to eq(-1)
      end

      it 'returns nil when not comparable' do
        expect(due_on_new(month: 2, day: 2) <=> 37).to be_nil
      end
    end

    describe '#to_s' do
      it 'outputs day and month without year' do
        expect(due_on_new.to_s).to eq '[Mar 25]'
      end

      it 'outputs year, month, day with year' do
        expect(due_on_new(year: 2002).to_s).to eq '[2002 Mar 25]'
      end

      it 'displays if marked for destruction' do
        (due_on = due_on_new).mark_for_destruction
        expect(due_on.to_s).to eq '[Mar 25 MFD]'
      end
    end
  end
end
