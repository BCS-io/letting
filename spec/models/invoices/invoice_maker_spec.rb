require 'rails_helper'
# rubocop: disable Metrics/LineLength

RSpec.describe InvoiceMaker, type: :model do
  describe '#compose' do
    it 'invoice accounts within property and due date range' do
      invoice_text_create id: 1

      invoice =
        InvoiceMaker.new property: property_new,
                         invoice_date: Date.new(2010, 2, 1),
                         comments: [],
                         snapshot: Snapshot.new(account: account_new)

      expect(invoice.compose.to_s)
        .to eq [%q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands"),
                %q(Property Ref: 2002),
                %q(Invoice Date: Mon, 01 Feb 2010),
                %q(Property Address: "Edgbaston Road\nBirmingham\nWest Midlands"),
                %q(client: "")].join "\n"
    end
  end
end
