# Is a one column table good design?
# http://stackoverflow.com/questions/951686/is-a-one-column-table-good-design
#
class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :name, null: false
      t.integer :order, null: false
      t.string :cycle_type, null: false
      t.timestamps
    end
  end
end