#
# Invoicings
#
#

after :templates do

  class << self
    def create_date months_ago
        on_date = Date.current - months_ago.months
        "#{on_date.year}/#{on_date.month }/01"
    end

    def create_debits

      Debit.create! [
        {
          id: 1,
          account_id: 1,
          invoice_account_id: 1,
          charge_id: 1,
          on_date: create_date(17),
          period:create_date(17)..create_date(14),
          amount: Charge.find(1).amount
        },
        {
          id: 2,
          account_id: 1,
          invoice_account_id: 1,
          charge_id: 2,
          on_date: create_date(5),
          period:create_date(5)..create_date(2),
          amount: Charge.find(2).amount
        },
      ]

      invoice_account = InvoiceAccount.new id: 1
      invoice_account.debited debits: Debit.all
      invoice_account.save!
    end

    def create_products
      charge_1 = Charge.find(1)
      charge_2 = Charge.find(2)
      Product.create! [
        { id: 1,
          invoice_id: 1,
          charge_type: charge_1.charge_type,
          date_due: create_date(5),
          amount: charge_1.amount,
          balance: charge_1.amount,
          period_first: create_date(5),
          period_last: create_date(2)
        },
        { id: 2,
          invoice_id: 1,
          charge_type: charge_2.charge_type,
          date_due: create_date(5),
          amount: charge_2.amount,
          balance: charge_1.amount + charge_2.amount,
          period_first: create_date(5),
          period_last: create_date(2)
        },
      ]
    end

    def create_invoices
      Invoice.create! [
        { id: 1,
          invoicing_id: 1,
          invoice_account_id: 1,
          billing_address: "Mr E. P. Hendren\nFlat 28 Lords\n2 St Johns Wood Road\nLondon\nGreater London\nNW8 8QN",
          property_ref: 1001,
          invoice_date: create_date(5),
          property_address: "Flat 28 Lords, 2 St Johns Wood Road, London, Greater London, NW8 8QN",
          total_arrears: Charge.find(1).amount * 2,
          client_address: "Mr K.S. Ranjitsinhji\nFlat 96 Old Trafford\nDean\nSeaford\nSuss\nBN6 7QP"
        },
      ]
    end

    def create_invoicings
      Invoicing.create! [
        { id: 1,
          property_range: "1001 - 1001",
          period_first: create_date(5),
          period_last: create_date(2),
        },
      ]
    end

    def create_letters
      Letter.create! [
        { id: 1,
          invoice_id: 1,
          template_id: 1,
        },
      ]
    end
  end

  create_debits
  create_products
  create_invoices
  create_letters
  create_invoicings
end