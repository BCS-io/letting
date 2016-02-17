require 'rails_helper'

describe InvoiceText, type: :model do
  describe 'validations' do
    it('returns valid') { expect(invoice_text_new).to be_valid }
    it('description') { expect(invoice_text_new description: '').to_not be_valid }
    it('needs name') { expect(invoice_text_new invoice_name: '').to_not be_valid }
    it('requires a phone') { expect(invoice_text_new phone: '').to_not be_valid }
    it('requires vat number') { expect(invoice_text_new vat: '').to_not be_valid }
    it('requires heading') { expect(invoice_text_new heading1: '').to_not be_valid }
  end
end
