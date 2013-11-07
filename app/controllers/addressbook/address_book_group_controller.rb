require_dependency "addressbook/application_controller"

module Addressbook
  class AddressBookGroupController < ApplicationController
    respond_to :html, :js

    before_filter :filter_current_account

    def filter_current_account
      @current_account = current_account
    end

    def index
      @account_contact_groups = @current_account.account_contact_groups
      respond_with(@account_contact_groups, :location => address_book_group_path)
    end

    def new
      @account_contact_group = AccountContactGroup.new
    end

    def create
      @account_contact_group = @current_account.account_contact_groups.new(params[:account_contact_group])
      @account_contact_group.save and flash[:notice] = "Yay! Contact group has been created!"
      respond_with(@account_contact_group, :location => address_book_group_path)
    end

    def update
      @account_contact_group = @current_account.account_contact_groups.find(params[:id])
      if !@account_contact_group
        redirect_to :action => 'index'
        return
      end
      puts "before update_attributes"
      @account_contact_group.update_attributes(params[:account_contact_group])
      puts "after update_attributes"
      respond_with(@account_contact_group, :location => address_book_group_edit_path)
    end

    def edit
      @account_contact_group = @current_account.account_contact_groups.find(params[:id])
      if !@account_contact_group
        redirect_to :action => 'index'
        return
      end
    end

    def delete 
      @account_contact_group = @current_account.account_contact_groups.find(params[:id])
      if @account_contact_group
        @account_contact_group.destroy
        flash[:notice] = "Destroyed!"
      end
      respond_with(@account_contact_group, :location => address_book_group_path)
      
    end

    #def show

    #end
  end
end
