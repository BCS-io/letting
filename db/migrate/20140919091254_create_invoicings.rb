class CreateInvoicings < ActiveRecord::Migration[4.2]
  def change
    create_table :invoicings do |t|
      t.string :property_range, null: false
      t.date   :period_first,      null: false
      t.date   :period_last,       null: false
      t.integer :runs_count, default: 0
      t.timestamps null: true
    end
  end
end
