class CreateChargeStructures < ActiveRecord::Migration
  def change
    create_table :charge_structures do |t|
      t.belongs_to :charged_in, null: false, index: true
      t.belongs_to :charge_cycle, null: false, index: true

      t.timestamps
    end
  end
end
