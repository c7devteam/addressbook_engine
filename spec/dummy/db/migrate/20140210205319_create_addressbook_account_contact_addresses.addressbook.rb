# This migration comes from addressbook (originally 20131101150739)
class CreateAddressbookAccountContactAddresses < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contact_addresses do |t|
      t.integer :account_contact_id
      t.string :line_1
      t.string :line_2
      t.string :line_3
      t.string :zip
      t.string :city
      t.string :country
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
