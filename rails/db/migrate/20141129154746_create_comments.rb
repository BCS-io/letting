class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.belongs_to :invoice, index: true, null: false
      t.string :clarify, null: false

      t.timestamps null: true
    end
  end
end
