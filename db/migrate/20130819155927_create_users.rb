class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :nickname, null:false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer  :role, default: 0, null: false
      t.timestamps null: true
    end

    add_index :users, :email, unique: true
  end
end
