class CreateDueOns < ActiveRecord::Migration[4.2]
  def change
    create_table :due_ons do |t|
      t.integer :year,       null: true
      t.integer :month,      null: false
      t.integer :day,        null: false
      t.integer :show_month, null: true
      t.integer :show_day,   null: true
      t.belongs_to :cycle, index: true, null: false
      t.timestamps null: true
    end
  end
end
