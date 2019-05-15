#
# polymorphic: true => two columns addressable_id and addressable_type
#
class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.belongs_to :addressable, polymorphic: true, null: false
      t.string :flat_no
      t.string :house_name
      t.string :road_no
      t.string :road, null: false
      t.string :district
      t.string :town
      t.string :county, null: false
      t.string :postcode
      t.string :nation
      t.timestamps null: true
    end
    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
