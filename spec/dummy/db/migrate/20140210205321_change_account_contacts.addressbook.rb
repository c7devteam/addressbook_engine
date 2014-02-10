# This migration comes from addressbook (originally 20131105155857)
class ChangeAccountContacts < ActiveRecord::Migration
  def up
  	add_column :addressbook_account_contacts, :owner_id, :integer
  	add_column :addressbook_account_contacts, :owner_type, :string
  	add_column :addressbook_account_contact_groups, :owner_id, :integer
  	add_column :addressbook_account_contact_groups, :owner_type, :string
    create_table :account_contact_groups_account_contacts, :id => false, :force => true do |t|
      t.integer "account_contact_group_id", :null => false
      t.integer "account_contact_id",       :null => false
    end
  end

  def down
  	remove_column :addressbook_account_contacts, :owner_id
  	remove_column :addressbook_account_contacts, :owner_type
  	remove_column :addressbook_account_contact_groups, :owner_id
  	remove_column :addressbook_account_contact_groups, :owner_type
  	drop_table :addressbook_account_contact_groups_addressbook_account_contacts
  end
end
