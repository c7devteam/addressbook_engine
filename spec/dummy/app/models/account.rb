class Account < ActiveRecord::Base
  has_secure_password
  #Contacts
  has_many :account_contacts, :class_name => 'Addressbook::AccountContact', as: :owner
  #Contacts
  has_many :account_contact_groups, :class_name => 'Addressbook::AccountContactGroup', as: :owner

  def full_name
    "#{first_name} #{last_name}"
  end
end
