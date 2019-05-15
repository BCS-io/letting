#
# InvoiceText
#
# Text for the invoice InvoiceText id: 1 is page 1, and id: 2 is page 2.
#
# InvoiceText                          Notice (join)
# id Description    invoice_name    id  instruction            Fill In
# 1  Page 1 Invoice F & L Adams     nil
# 2  Page 2         F & L Adams     1  [Insert leaseholder]    To
#                                   2  [address of premises]   This notice is
#                                   3  [Insert date]           Requires rent
#                                   ..
#                                   7  [Insert Landlord name]  To
#

class << self

  def create_invoice_texts
    InvoiceText.create! [
      { id: 1,
        description: "Invoices Page 1",
        invoice_name: "F & L Adams",
        phone: "1215030992",
        vat: "277 9904 95",
        heading1: "Lettings",
        heading2: "Invoice",
        advice1: "Hearby notice ",
        advice2: "Remittance Advice",
      },
      { id: 2,
        description:"Ground Rents Only Page 2",
        invoice_name: "F & L Adams",
        phone: "1215030992",
        vat: "277 9904 95",
        heading1: "Common Leasehold",
        heading2: "Notice to ",
        advice1: "NOTICE LEASES",
        advice2: "NOTES LANDLORDS",
      },
    ]

    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'InvoiceText',
        flat_no:  '',
        house_name: '',
        road_no:  '77',
        road:     'Henley Road',
        district: 'Edgbaston',
        town:     'Birmingham',
        county:   'West Midlands',
        postcode: 'B32 7NR'
      }
    ]

  end

  def create_guides
    Guide.create! [
      { id: 1,
        invoice_text_id: 2,
        instruction: "Insert leaseholder",
        fillin: "To",
        sample: "Ms Sample"
      },
      { id: 2,
        invoice_text_id: 2,
        instruction: "Address of premises",
        fillin: "This notice",
        sample: "27 High St"
      },
      { id: 3,
        invoice_text_id: 2,
        instruction: "Insert date",
        fillin: "It requires",
        sample: "21st June"
      },
      { id: 4,
        invoice_text_id: 2,
        instruction: "[State Period]",
        fillin: "Payable for period",
        sample: "20March-29th Sep",
      },
      { id: 5,
        invoice_text_id: 2,
        instruction: "[Insert Landlord name]",
        fillin: "Pay to",
        sample: "Mr Collector",
      },
      { id: 6,
        invoice_text_id: 2,
        instruction: "[Insert address]",
        fillin: "at",
        sample: "11 High Street",
      },
      { id: 7,
        invoice_text_id: 2,
        instruction: "[Insert Landlord name]",
        fillin: "To",
        sample: "CLIENT NAME",
      },

    ]
  end

end

create_invoice_texts
create_guides
