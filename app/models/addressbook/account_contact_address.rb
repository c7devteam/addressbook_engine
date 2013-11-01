module Addressbook
  class AccountContactAddress < ActiveRecord::Base
    #attr_accessible :account_contact_id, :city, :country, :deleted_at, :line_1, :line_2, :line_3, :zip
    attr_accessible :line_1, :line_2, :line_3, :zip, :city, :country
    acts_as_paranoid
    #validates :line_1, presence: true
  end
end
