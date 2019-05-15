class CreateRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :runs do |t|
      t.belongs_to :invoicing, index: true
      t.date :invoice_date, null: false
      t.timestamps null: true
    end
  end
end
