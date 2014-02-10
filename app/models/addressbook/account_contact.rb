module Addressbook
  class AccountContact < ActiveRecord::Base
    require 'tire'
    #attr_accessible :account_id, :deleted_at, :first_name, :image, :last_name, :title, :usernotice
    def email
      preferred_email
    end

    include Tire::Model::Search
    include Tire::Model::Callbacks
    require "contact_importer"
    acts_as_paranoid

   # attr_accessible :first_name, :last_name, :account_contact_group_ids,
    #                :account_contact_emails_attributes, :account_contact_telephones_attributes,
     #               :account_contact_addresses_attributes, :image, :title, :usernotice, :account_id,
      #              :owner_id, :owner_type

    belongs_to :owner, polymorphic: true
    has_many :account_contact_emails, dependent: :destroy
    has_many :account_contact_telephones, dependent: :destroy
    has_many :account_contact_addresses, dependent: :destroy
    has_and_belongs_to_many :account_contact_groups, class_name: "Addressbook::AccountContactGroup"

    accepts_nested_attributes_for :account_contact_telephones, allow_destroy: true
    accepts_nested_attributes_for :account_contact_emails, allow_destroy: true
    accepts_nested_attributes_for :account_contact_addresses, allow_destroy: true

    mount_uploader :image, AccountContactImageUploader

    mapping do
      indexes :id, :type => 'integer', :index => :not_analyzed
      indexes :first_name
      indexes :last_name
      indexes :first_letter
      indexes :contact_groups, type: 'string'
      indexes :emails, type: 'string'
      indexes :phones, type: 'string'
    end


    def self.search(params, current_account)
      tire.search(load: true, page: params[:page] || 1, per_page: 20) do
        query { string params[:query], default_operator: "AND" } if params[:query].present?
        filter :term, owner_id: current_account.id
        filter :term, first_letter: params[:first_letter] if params[:first_letter].present?
        filter :term, contact_groups: params[:contact_groups] if params[:contact_groups].present?
        sort do
          by :last_name
          by :first_name
        end
        facet "letters" do
          terms :first_letter, :order => 'term', :size => 10000 #<- !!!
          facet_filter :term, owner_id: current_account.id
        end
        facet "contact_groups" do
          terms :contact_groups, :order => 'term', :size => 9000 #<- !!!
          facet_filter :term, owner_id: current_account.id
        end
      end
    end

    def to_indexed_json
      to_json(methods: [:first_letter, :phones, :emails])
    end

    def fullname
      "#{first_name} #{last_name}"
    end

    def contact_short
      "#{fullname}(#{preferred_email})"
    end

    #############deprecated methods###############
    def to_s
      fullname
    end

    def full_name
      to_s
    end
    ##############################################

    def initials
      initials = ""
      initials <<  first_name.first if !first_name.nil?
      initials <<  last_name.first if !last_name.nil?
    end

    def first_letter
      letter = last_name.first if !last_name.nil?
      if last_name.nil? || letter.nil? || letter.empty? || (1..10).to_a.inspect.include?(letter)
        letter = "none"
      else
        letter = last_name.first
      end
      puts "letter #{letter.downcase}"
      return "let_"+letter.downcase
    end

    def contact_groups
      puts "contact_groups #{@contact_groups ||= account_contact_groups.sekect(:name)}"
      @contact_groups ||= account_contact_groups.select(:name)
    end

    def phones
      puts "phones #{@phones ||= account_contact_telephones.pluck(:number)}"
      @phones ||= account_contact_telephones.pluck(:number)
    end

    def emails

      puts "emails #{@emails ||= account_contact_emails.pluck(:email)}"
      @emails ||= account_contact_emails.pluck(:email)
    end

    def preferred_email
      account_contact_emails.where(preferred: true).first.try(:email) || account_contact_emails.first.try(:email)
    end

    def image_url(version ="original")
      #return "/cdn/account_contact/image/#{self.id}/#{version}/#{file_name}"
      #return "#{Rails.root}/public/uploads/addressbook/account_contact/image/#{self.id}/#{version}/#{file_name}"
      return image.url #stub
    end

    def file_name
      read_attribute :image
    end

    def self.import_vcard(account, vcard_path)
      # vcard = account.account_v_cards.new
      # vcard.filename = vcard_path
      # vcard.save!

      data = IO.read(vcard_path)
      ci = ContactImporter.new(data)
      contacts = ci.parse
      contacts.each do |parsed_contact|
        contact = account.account_contacts.find_by_first_name_and_last_name(parsed_contact.first_name, parsed_contact.last_name)
        if !contact
          contact = account.account_contacts.new
          contact.first_name = parsed_contact.first_name
          contact.last_name = parsed_contact.last_name
          contact.save
          if parsed_contact.photo
            contact.image = CarrierStringIO.new(parsed_contact.photo)
            if contact.store_image!
              puts "Image stored"
            end
            contact.save
          end
          contact.save
          puts "created new contact #{contact.first_name} #{contact.last_name}"
        end
        # the mail addresses
        parsed_contact.emails.each do |email_data|
          contact_email = AccountContactEmail.where("account_contact_id=? AND email=?",contact.id,email_data['address']).first
          if !contact_email
            contact_email = AccountContactEmail.new
            contact_email.email = email_data['address']
            contact_email.preferred = email_data['preferred']
            contact_email.account_contact_id = contact.id
            contact_email.save
            puts "created new email #{contact_email.email} for #{contact.first_name} #{contact.last_name}"
          end
        end
        #telephone
        parsed_contact.phone_numbers.each do |phone_number|
          contact_phone = AccountContactTelephone.where("account_contact_id=? AND number=?",contact.id,phone_number['number']).first
          if !contact_phone
            contact_phone = AccountContactTelephone.new
            contact_phone.number = phone_number['number']
            contact_phone.preferred = phone_number['preferred']
            contact_phone.account_contact_id = contact.id
            contact_phone.save
            puts "created new phone number #{contact_phone.number} for #{contact.first_name} #{contact.last_name}"
          end
        end
        #address
        parsed_contact.addresses.each do |address|
          contact_address = AccountContactAddress.where("account_contact_id=? AND line_1=? AND line_2=? AND line_3=?",contact.id,address['line_1'], address['line_2'], address['line_3']).first
          if !contact_address
            contact_address = AccountContactAddress.new
            contact_address.line_1 = address['line_1']
            contact_address.line_2 = address['line_2']
            contact_address.line_3 = address['line_3']
            contact_address.zip = address['zip']
            contact_address.city = address['city']
            contact_address.country = address['country']
            #contact_address.preferred = phone_number['preferred']
            contact_address.account_contact_id = contact.id
            contact_address.save
            puts "created new address #{contact_address.line_1} #{contact_address.line_2} #{contact_address.line_3} for #{contact.first_name} #{contact.last_name}"
          end
        end
      end
    end
  end
end
