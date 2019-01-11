class CreateGuides < ActiveRecord::Migration[4.2]
  def change
    create_table :guides do |t|
      t.belongs_to :invoice_text, null: false, index: true
      t.text :instruction, null: false
      t.text :fillin, null: false
      t.text :sample, null: false
      t.timestamps null: true
    end
  end
end
