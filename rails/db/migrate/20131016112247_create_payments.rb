class CreatePayments < ActiveRecord::Migration[4.2]
  def change
    create_table :payments do |t|
      t.belongs_to :account, null: false, index: true
      t.datetime :booked_at, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.timestamps null: true
    end
  end
end
