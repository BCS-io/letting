require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe InvoiceMaker, type: :model do
  describe '#compose' do
    it 'invoice accounts within property and due date range' do
      invoice_text_create id: 1
      charge = charge_create cycle: cycle_new(due_ons: [due_on_new(month: 3)])
      account = account_create property: property_new, charges: [charge]

      invoice =
        InvoiceMaker.new account: account,
                         period: Date.new(2010, 2, 1)..Date.new(2010, 5, 1),
                         invoice_date: Date.new(2010, 2, 1),
                         comments: [],
                         snapshot: Snapshot.new(account: account)

      expect(invoice.compose.to_s)
        .to eq [%q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands"),
                %q(Property Ref: 2002),
                %q(Invoice Date: Mon, 01 Feb 2010),
                %q(Property Address: "Edgbaston Road\nBirmingham\nWest Midlands"),
                %q(client: "")].join "\n"
    end
  end
end
