class CreateCredits < ActiveRecord::Migration[4.2]
  def change
    create_table :credits do |t|
      t.belongs_to  :account, null: false, index: true
      t.belongs_to  :charge,  null: false, index: true
      t.belongs_to  :payment, null: false, index: true
      t.datetime    :at_time,    null: false
      t.datetime    :deleted_at,    null: true
      t.decimal  :amount, precision: 8, scale: 2, null: false
      t.timestamps null: true
    end
  end
end
