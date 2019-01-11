class CreateProperties < ActiveRecord::Migration[4.2]
  def change
    create_table :properties do |t|
      t.integer :human_ref, null: false
      t.belongs_to :client, index: true
      t.timestamps null: true
    end
  end
end
