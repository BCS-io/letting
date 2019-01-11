class CreateCharges < ActiveRecord::Migration[4.2]
  def change
    create_table :charges do |t|
      t.string :charge_type, null: false
      t.belongs_to :account, null: false, index: true
      t.belongs_to :cycle, null: false, index: true
      t.integer :payment_type, null: false
      t.decimal :amount, precision: 8, scale: 2, null:false
      t.integer  :activity, default: 0, null: false
      t.timestamps null: true
    end
  end
end
