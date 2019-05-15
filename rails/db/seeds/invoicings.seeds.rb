#
# Invoicings
#
#

after :invoice_texts do

  class << self
    def create_date months_ago
        at_time = Time.zone.today - months_ago.months
        "#{at_time.year}/#{at_time.month }/01"
    end

    def create_debits

      Debit.create! [
        {
          id: 1,
          account_id: 1,
          snapshot_id: 1,
          charge_id: 1,
          at_time: create_date(17),
          period:create_date(17)..create_date(14),
          amount: Charge.find(1).amount
        },
        {
          id: 2,
          account_id: 1,
          snapshot_id: 1,
          charge_id: 2,
          at_time: create_date(5),
          period:create_date(5)..create_date(2),
          amount: Charge.find(2).amount
        },
      ]

      snapshot = Snapshot.new id: 1, account_id: 1, period: create_date(17)..
                                                            create_date(2)
      snapshot.debited debits: Debit.all
      snapshot.save!
    end

    def create_products
      charge_1 = Charge.find(1)
      charge_2 = Charge.find(2)
      Product.create! [
        { id: 1,
          invoice_id: 1,
          charge_type: charge_1.charge_type,
          date_due: create_date(5),
          payment_type: 'manual',
          amount: charge_1.amount,
          balance: charge_1.amount,
          period_first: create_date(5),
          period_last: create_date(2)
        },
        { id: 2,
          invoice_id: 1,
          charge_type: charge_2.charge_type,
          date_due: create_date(5),
          payment_type: 'manual',
          amount: charge_2.amount,
          balance: charge_1.amount + charge_2.amount,
          period_first: create_date(5),
          period_last: create_date(2)
        },
      ]
    end


    def create_runs
      Run.create! [
        { id: 1,
          invoicing_id: 1,
          invoice_date: create_date(5),
        },
      ]
    end


    def create_invoices
      Invoice.create! [
        { id: 1,
          run_id: 1,
          color: 'blue',
          snapshot_id: 1,
          deliver: 'mail',
          invoice_date: create_date(5),
          property_ref: 1001,
          occupiers: "Mr E. P. Hendren",
          property_address: "Flat 28 Lords\n2 St Johns Wood Road\nLondon\nGreater London\nNW8 8QN",
          billing_address: "Mr E. P. Hendren\nFlat 28 Lords\n2 St Johns Wood Road\nLondon\nGreater London\nNW8 8QN",
          client_address: "Mr K.S. Ranjitsinhji\nFlat 96 Old Trafford\nDean\nSeaford\nSuss\nBN6 7QP",
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
          invoice_text_id: 1,
        },
      ]
    end
  end

  create_debits
  create_products
  create_invoices
  create_runs
  create_letters
  create_invoicings
end
