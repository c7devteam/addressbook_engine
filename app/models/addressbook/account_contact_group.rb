module Addressbook
  class AccountContactGroup < ActiveRecord::Base
    #attr_accessible :account_id, :deleted_at, :name
    
    belongs_to :owner, polymorphic: true
    has_and_belongs_to_many :account_contacts
    attr_accessible :name, :account_contact_ids,
    :owner_id, :owner_type
    validates :owner, presence: true
    validates :name, presence: true

  end
end
