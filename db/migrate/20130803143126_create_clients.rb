class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :human_ref, null: false

      t.timestamps null: true
    end
  end
end
