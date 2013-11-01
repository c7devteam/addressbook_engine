module Addressbook
  class AccountContactTelephone < ActiveRecord::Base
    #attr_accessible :account_contact_id, :deleted_at, :number, :preferred
  	attr_accessible :number, :preferred
  	acts_as_paranoid
  	validates :number, presence: true
  end
end
