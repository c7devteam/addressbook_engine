module Addressbook
  class AccountContactEmail < ActiveRecord::Base
    #attr_accessible :account_contact_id, :deleted_at, :email, :preferred
    include Tire::Model::Search
    include Tire::Model::Callbacks
    acts_as_paranoid

    #attr_accessible :email, :preferred

    validates :email, presence: true

    belongs_to :account_contact

    delegate :account, to: :account_contact
    delegate :contact_groups, to: :account_contact
    delegate :phones, to: :account_contact
    delegate :first_letter, to: :account_contact

    mapping do
      indexes :id, type: "integer", index: :not_analyzed
      indexes :email

      indexes :account_contact_name, type: 'string'
      indexes :contact_groups, type: 'string'
      indexes :phones, type: 'string'
      indexes :first_letter
    end

    def to_indexed_json
      to_json(methods: [:account_contact_name])
    end

    def account_contact_name
      account_contact.fullname
    end

    def to_s
      "#{account_contact.to_s}(#{email})"
    end

    def search(*args)
      owner_id = args[1].delete(:owner_id)
      tire.search(*args) do
        filter :term, owner_id: owner_id
      end
    end
  end
end
