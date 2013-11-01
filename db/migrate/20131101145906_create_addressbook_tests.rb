class CreateAddressbookTests < ActiveRecord::Migration
  def change
    create_table :addressbook_tests do |t|
      t.string :name

      t.timestamps
    end
  end
end
