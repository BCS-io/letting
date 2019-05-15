class CreateInvoiceTexts < ActiveRecord::Migration[4.2]
  def change
    create_table :invoice_texts do |t|
      t.string :description,  null: false
      t.string :invoice_name,  null: false
      t.string :phone,  null: false
      t.string :vat,  null: false
      t.string :heading1,  null: false
      t.string :heading2,  null: false
      t.text :advice1,  null: false
      t.text :advice2,  null: false
      t.timestamps null: true
    end
  end
end
