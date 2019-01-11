class CreateProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :products do |t|
      t.belongs_to :invoice, null: false, index: true
      t.string  :charge_type, null: false
      t.date    :date_due, null: false
      t.integer :payment_type, null: false
      t.date    :period_first
      t.date    :period_last
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.decimal  :balance, precision: 8, scale: 2, null: false
      t.timestamps null: true
    end
  end
end
