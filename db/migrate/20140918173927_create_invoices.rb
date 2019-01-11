class CreateInvoices < ActiveRecord::Migration[4.2]
  def change
    create_table :invoices do |t|
      t.belongs_to :run, null: false, index: true
      t.belongs_to :snapshot, null: false, index: true
      t.integer  :color, null: false
      t.integer  :deliver, null: false
      t.date     :invoice_date, null: false
      t.integer  :property_ref,    null: false
      t.text     :occupiers, null: false
      t.text     :property_address, null: false
      t.text     :billing_address, null: false
      t.text     :client_address, null: false
      t.timestamps null: true
    end
  end
end
