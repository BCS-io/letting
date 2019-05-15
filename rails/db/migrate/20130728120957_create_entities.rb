#
# polymorphic: true => two columns entitieable_id and enitieable_type
#
class CreateEntities < ActiveRecord::Migration[4.2]
  def change
    create_table :entities do |t|
      t.belongs_to :entitieable, polymorphic: true, null: false
      t.string :title
      t.string :initials
      t.string :name, null: false
      t.timestamps null: true
    end
    add_index :entities, [:entitieable_id, :entitieable_type]
  end
end
