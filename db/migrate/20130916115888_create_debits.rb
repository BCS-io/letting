class CreateDebits < ActiveRecord::Migration
  def change
    create_table :debits do |t|
      t.belongs_to  :account, null: false, index: true
      t.belongs_to  :snapshot, index: true
      t.belongs_to  :charge_id,  null: false, index: true
      t.datetime :at_time,    null: false
      t.date     :period_first,      null: false
      t.date     :period_last,       null: false
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps null: true
    end
    add_index :debits, [:charge_id, :at_time], unique: true
  end
end
