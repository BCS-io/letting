class AccountDetails < ActiveRecord::Migration[4.2]
  def up
    self.connection.execute %Q( CREATE VIEW account_details AS
      SELECT accounts.id as account_id, property_id, human_ref, at_time, coalesce(credits.amount * -1, 0) as amount
      FROM "accounts"
      LEFT JOIN credits ON credits.account_id = accounts.id
      INNER JOIN properties ON properties.id = accounts.property_id
      UNION ALL
      SELECT accounts.id  as account_id, property_id, human_ref, at_time, coalesce(debits.amount, 0) as amount
      FROM "accounts"
      LEFT JOIN debits ON debits.account_id = accounts.id
      INNER JOIN properties ON properties.id = accounts.property_id
    )
  end

  def down
    self.connection.execute 'DROP VIEW IF EXISTS account_details;'
  end
end
