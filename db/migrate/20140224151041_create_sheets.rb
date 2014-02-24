class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :adams_name
      t.string :street
      t.string :district
      t.string :county
      t.string :postcode
      t.string :phone
      t.string :vat
      t.string :inv
      t.string :prop_ref
      t.string :date
      t.string :prop_add
      t.string :col1
      t.string :col2
      t.string :col3
      t.string :col4
      t.string :col5
      t.string :tot
      t.string :due
      t.string :from
      t.string :heading
      t.string :behalf
      t.string :notice_pursuant
      t.string :remit_heading
      t.string :remit
      t.string :payable_cheques
      t.string :dotted
      t.string :section
      t.string :notice_heading
      t.string :small1
      t.string :small2
      t.string :small3
      t.string :small4
      t.string :small5
      t.string :small6
      t.string :small7
      t.string :note1
      t.string :note2
      t.string :note3
      t.string :note4
      t.string :note5
      t.string :note6
      t.string :note7
      t.string :leaseholder_heading
      t.string :landlord_heading
      t.string :small_note1
      t.string :small_note2
      t.string :small_note3
      t.string :small_note4

      t.timestamps
    end
  end
end
