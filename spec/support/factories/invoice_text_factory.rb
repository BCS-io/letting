# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def invoice_text_new id: nil,
                     description: 'Page 1 Invoice',
                     invoice_name: 'Bell',
                     phone: '01710008',
                     vat: '89',
                     heading1: 'Property Management',
                     heading2: 'Property Ref',
                     advice1: 'Give you notice',
                     advice2: 'Remittance Advice',
                     address: address_new
  InvoiceText.new id: id,
                  description: description,
                  invoice_name: invoice_name,
                  phone: phone,
                  vat: vat,
                  heading1: heading1,
                  heading2: heading2,
                  advice1: advice1,
                  advice2: advice2,
                  address: address
end

def invoice_text_create id: 1,
                        description: 'Page 1 Invoice',
                        invoice_name: 'Bell',
                        phone: '01710008',
                        vat: '89',
                        heading1: 'Property Management',
                        heading2: 'Property Ref',
                        advice1: 'Give you notice',
                        advice2: 'Remittance Advice',
                        address: address_new
  InvoiceText.create! id: id,
                      description: description,
                      invoice_name: invoice_name,
                      phone: phone,
                      vat: vat,
                      heading1: heading1,
                      heading2: heading2,
                      advice1: advice1,
                      advice2: advice2,
                      address: address
end
