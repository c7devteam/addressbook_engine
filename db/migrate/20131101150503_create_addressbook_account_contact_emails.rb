class CreateAddressbookAccountContactEmails < ActiveRecord::Migration
  def change
    create_table :addressbook_account_contact_emails do |t|
      t.integer :account_contact_id
      t.string :email
      t.boolean :preferred
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
