class CreateAgents < ActiveRecord::Migration[4.2]
  def change
    create_table :agents do |t|
      t.boolean :authorized, null: false, default: false
      t.belongs_to :property, null: false, index: true
      t.timestamps null: true
    end
  end
end

