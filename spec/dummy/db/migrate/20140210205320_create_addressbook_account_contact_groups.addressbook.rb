# This migration comes from addressbook (originally 20131101150950)
class CreateAddressbookAccountContactGroups < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contact_groups do |t|
      t.string :name
      t.string :account_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
