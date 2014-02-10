# This migration comes from addressbook (originally 20131101150624)
class CreateAddressbookAccountContactTelephones < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contact_telephones do |t|
      t.string :number
      t.integer :account_contact_id
      t.boolean :preferred
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
