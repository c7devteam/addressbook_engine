require_dependency "addressbook/application_controller"
module Addressbook
  class AddressBookController < ApplicationController

	require 'kaminari'
  require 'kaminari/models/array_extension'
  
  respond_to :html, :js


  before_filter :filter_current_account

  def filter_current_account
    @current_account = current_account
  end

  def index
    begin
      #@contacts = @current_account.account_contacts.search(params, @current_account)
      @contacts = @current_account.account_contacts.page(params[:page]).per(20)
      if @contacts.empty? 
        @contacts = Kaminari.paginate_array(Array.new) 
      end
    rescue Exception => ex
      @contacts = Kaminari.paginate_array(Array.new)
    end
    puts "contacts #{@contacts.inspect}"
    respond_with(@contacts, :location => account_contacts_path)

  end

  def import_vcard
    num_imports = AccountContact::import_vcard(@current_account,params[:vcard].tempfile)
    #flash[:notice] = I18n.t('general.address_book.notices.imported_n_contacts',:count => num_imports)
    redirect_to :action => 'index'
  end

  def new 
    puts "meth #{current_account}"
    puts "inst #{@current_account}"
    @account_contact = @current_account.account_contacts.build
    respond_with(@account_contact, :location => new_contact_path)
  end

  def edit
    @account_contact = AccountContact.where("account_id=? AND id=?",@current_account.id,params[:id]).first
    if !@account_contact
      redirect_to :action => 'index'
      return
    end
    @options_for_select = @current_account.account_contact_groups.map { |group| [group.name, group.id] }
  end

  def update
    if params[:id] == "nil"
     # @account_contact = AccountContact.create(:account_id => @current_account.id)
     @account_contact = current_account.account_contacts.create
    else
      @account_contact = AccountContact.where("account_id=? AND id=?",@current_account.id,params[:id]).first
      if !@account_contact
        redirect_to :action => 'index'
        return
      end
    end
    check_attributes(params)
    @account_contact.update_attributes(params[:account_contact])
    if params["called"]
      respond_with(@account_contact, :location => edit_contact_path)
    else
      respond_with(@called = true)
    end
  end

  def delete
    @contact = AccountContact.where("account_id=? AND id=?",@current_account.id,params[:id]).first
    if @contact
      @contact.destroy
      flash[:notice] = "Destroyed!"
    end
    respond_with(@contact, :location => account_contacts_path)
    
  end

  def delete_attribute
    @contact = AccountContact.where("account_id=? AND id=?",@current_account.id,params[:contact_id]).first
    @type = params[:type]
    if !@contact
      respond_with(:location => account_contacts_path)
      return
    end
    if @type == "email"
      @contact_data = AccountContactEmail.where("account_contact_id=? AND id=?",@contact.id,params[:id]).first
    elsif @type == "telephone"
      @contact_data = AccountContactTelephone.where("account_contact_id=? AND id=?",@contact.id,params[:id]).first 
    elsif @type == "address"
      @contact_data = AccountContactAddress.where("account_contact_id=? AND id=?",@contact.id,params[:id]).first
    end
    
    if @contact_data
      @contact_data.destroy
    end
    respond_with(@contact_data, @type, :location => edit_contact_path(@contact)) 
  end

  private
    def check_attributes params
      p = params["account_contact"]
      p["account_contact_emails_attributes"].select!{|key, val| val["email"].present?} if p["account_contact_emails_attributes"]
      p["account_contact_telephones_attributes"].select!{|key, val| val["number"].present?} if p["account_contact_telephones_attributes"]
      p["account_contact_addresses_attributes"].select!{|key, val| val["line_1"].present? || val["line_2"].present? || val["line_3"].present? || val["zip"].present? || val["country"].present? || val["city"].present?} if p["account_contact_addresses_attributes"]
    end
  end
end
