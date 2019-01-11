class CreateLetters < ActiveRecord::Migration[4.2]
  def change
    create_table :letters do |t|
      t.belongs_to :invoice, null: false, index: true
      t.belongs_to :invoice_text, null: false, index: true

      t.timestamps null: true
    end
  end
end
