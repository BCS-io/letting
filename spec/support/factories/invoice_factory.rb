# rubocop: disable Metrics/ParameterLists, Metrics/MethodLength

# invoice_new and invoice_create require that a invoice_text with id 1 has been
# created BEFORE invoice.prepare is called.
# By default the factory creates the invoice_text
# With the method argument: invoice_texts: [invoice_text_create(id: 1)]

def invoice_new id: nil,
                run_id: 5,
                color: :blue,
                invoice_date: '2014/06/30',
                property: property_new(account: account_create),
                comments: [],
                snapshot: snapshot_new,
                deliver: 'mail'
  snapshot.account = property.account if property.account
  invoice_text_create(id: 1) unless InvoiceText.find_by id: 1
  invoice = Invoice.new id: id, run_id: run_id
  invoice.snapshot = snapshot
  invoice.prepare invoice_date: invoice_date,
                  color: color,
                  property: property.invoice,
                  snapshot: snapshot,
                  comments: comments
  invoice.deliver = deliver
  invoice
end

def invoice_create \
  id: nil,
  run_id: 6,
  invoice_date: '2014/06/30',
  property: property_create,
  comments: [],
  snapshot: snapshot_new,
  deliver: 'mail'

  invoice = invoice_new id: id,
                        run_id: run_id,
                        invoice_date: invoice_date,
                        property: property,
                        comments: comments,
                        snapshot: snapshot,
                        deliver: deliver
  invoice.save!
  invoice
end
