class User < ActiveRecord::Base
  #attr_accessible :email, :first_name, :last_name
  #Contacts
  has_many :account_contacts, :class_name => 'Addressbook::AccountContact', as: :owner
  #Contacts
  has_many :account_contact_groups, :class_name => 'Addressbook::AccountContactGroup', as: :owner
end
