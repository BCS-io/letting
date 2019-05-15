class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.belongs_to :property, index: true, null: false
      t.timestamps null: true
    end
  end
end
