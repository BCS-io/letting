class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.belongs_to :account, null: false, index: true
      t.date     :period_first,   null: false
      t.date     :period_last,    null: false
      t.timestamps null: true
    end
  end
end
