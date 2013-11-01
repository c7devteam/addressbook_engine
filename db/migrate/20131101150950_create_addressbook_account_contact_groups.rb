class CreateAddressbookAccountContactGroups < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contact_groups do |t|
      t.string :name
      t.string :account_id
      t.datetime :deleted_at

      t.timestamps
    end
    create_table "account_contact_groups_account_contacts", :id => false, :force => true do |t|
      t.integer "account_contact_group_id", :null => false
      t.integer "account_contact_id",       :null => false
    end
  end
end
