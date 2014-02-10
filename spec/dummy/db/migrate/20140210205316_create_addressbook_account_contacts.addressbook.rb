# This migration comes from addressbook (originally 20131101150350)
class CreateAddressbookAccountContacts < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contacts do |t|
      t.integer :account_id
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :image
      t.datetime :deleted_at
      t.string :usernotice

      t.timestamps
    end
  end
end
