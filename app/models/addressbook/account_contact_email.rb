module Addressbook
  class AccountContactEmail < ActiveRecord::Base
    #attr_accessible :account_contact_id, :deleted_at, :email, :preferred
    acts_as_paranoid

    attr_accessible :email, :preferred

    validates :email, presence: true

    belongs_to :account_contact

    delegate :account, to: :account_contact

    def to_s
      "#{account_contact.to_s}(#{email})"
    end
  end
end
