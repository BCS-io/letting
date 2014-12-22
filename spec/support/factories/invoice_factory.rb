# rubocop: disable Metrics/ParameterLists, Metrics/MethodLength, Metrics/LineLength
# rubocop: disable Lint/UnusedMethodArgument

# invoice_new and invoice_create require that a invoice_text with id 1 has been
# created BEFORE invoice.prepare is called.
# By default the factory creates the invoice_text
# With the method argument: invoice_texts: [invoice_text_create(id: 1)]

def invoice_new id: nil,
                run_id: 5,
                invoice_date: '2014/06/30',
                account: account_create,
                property: property_new,
                comments: [],
                debits_transaction: debits_transaction_new,
                products: [product_new],
                deliver: true
  invoice_text_create(id: 1) unless InvoiceText.find_by id: 1
  account.property = property
  invoice = Invoice.new id: id, run_id: run_id
  invoice.debits_transaction = debits_transaction
  invoice.prepare account: account,
                  invoice_date: invoice_date,
                  property: account.property.invoice,
                  debits_transaction: debits_transaction,
                  comments: comments,
                  products: products
  invoice.deliver = deliver
  invoice
end

def invoice_create \
  id: nil,
  run_id: 6,
  invoice_date: '2014/06/30',
  account: account_create,
  property: property_create,
  comments: [],
  debits_transaction: debits_transaction_new,
  products: [product_new],
  deliver: true

  invoice = invoice_new id: id,
                        run_id: run_id,
                        invoice_date: invoice_date,
                        account: account,
                        property: property,
                        comments: comments,
                        debits_transaction: debits_transaction,
                        products: products,
                        deliver: deliver
  invoice.save!
  invoice
end
