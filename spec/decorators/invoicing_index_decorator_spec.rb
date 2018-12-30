require 'rails_helper'

describe InvoicingIndexDecorator do
  it '#created_at' do
    Timecop.travel(Time.zone.local(2008, 9, 1, 10, 5, 1)) do
      property_create human_ref: 1, account: account_new
      invoicing_dec = InvoicingIndexDecorator.new \
        invoicing_create property_range: '1-2'

      expect(invoicing_dec.created_at).to eq '01 Sep 2008 10:05'
    end
  end

  it '#period_between - displays formatted date' do
    invoicing_dec = InvoicingIndexDecorator.new \
      invoicing_new period: '2010-3-25'..'2010-6-25'
    expect(invoicing_dec.period_between).to eq '25/Mar/10 - 25/Jun/10'
  end
end
