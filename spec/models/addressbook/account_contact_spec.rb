require 'spec_helper'

module Addressbook
  describe AccountContact do
    context "message passing" do
    let(:account) {double(:account)}
    let(:data) {double(:data)}
    let(:contact_importer_instance) {double(:contact_importer_instance)}
    before do
      @vcard = double(:vcard)
      account.stub(:account_v_cards).and_return(@vcard)
      @vcard.stub(:filename=).and_return(true)
      @vcard.stub(:save!).and_return(true)
      @vcard.stub(:new).and_return(@vcard)
      ContactImporter.stub(:new).and_return(contact_importer_instance)
      contact_importer_instance.stub(:parse).and_return([])
      IO.stub(:read).and_return(data)
      @vcard_path = ""
    end
    it "should pass correct messages to AccountContact" do
      ContactImporter.should_receive(:new).with(data).and_return(contact_importer_instance)
      contact_importer_instance.should_receive(:parse).and_return([])
      AccountContact.import_vcard(account, "")
    end
  end
  context "Importing vcards" do
    before (:all) do
      AccountContact.delete_all
    end

    before do 
      #@user = FactoryGirl.build(:account)
      @user = double(:user)
      @user.stub(:id=).and_return(true)
      @user.stub(:id).and_return(1)
      @user.stub(:save).and_return(true)
      @vcard = double(:vcard)
      @user.stub(:account_v_cards).and_return(@vcard)
      @vcard.stub(:filename=).and_return(true)
      @vcard.stub(:save!).and_return(true)
      @vcard.stub(:new).and_return(@vcard)
      @user.id = 1
      @user.save
      vcard = @user.account_v_cards
      allow(vcard).to receive(:filename=) {true}
      allow(vcard).to receive(:filename) {true}
      allow(vcard).to receive(:save) {true}
      @importing = proc{ AccountContact.import_vcard(@user, fixture_path+"/outlook.vcf") }
    end
    it "Should import vcards" do
      expect{@importing.call}.to change{AccountContact.count}.by(1)
      contact = AccountContact.first
      expect(contact.account_id).to eq(1)
      expect(contact.first_name).to eq("Slava")
      expect(contact.last_name).to eq("Dubovitsky")
      expect(contact.image).not_to be_nil
    end
    # it "Shouldn't import vcards twice" do 
    #   @importing.call
    #   expect{@importing.call}.to raise_error
    #   #expect{@importing.call}.to_not change{AccountContact.count}.by(1)
    # end
    it "Should import email data" do
      expect{@importing.call}.to change{AccountContactEmail.count}.by(1)
      contact = AccountContact.first
      contact_email = AccountContactEmail.first
      expect(contact_email.email).to eq("dslava@diatomenterprises.com")
      expect(contact_email.preferred).to be_true
      expect(contact_email.account_contact_id).to eq(contact.id)
    end
    # it "Shouldn't import emails twice" do 
    #   @importing.call
    #   expect{@importing.call}.to raise_error
    #  # expect{@importing.call}.to_not change{AccountContactEmail.count}.by(1)
    # end
    it "Should import phone data" do
      expect{@importing.call}.to change{AccountContactTelephone.count}.by(1)
      contact = AccountContact.first
      contact_telephone = AccountContactTelephone.first
      expect(contact_telephone.number).to eq("07875 338283")
      expect(contact_telephone.preferred).to be_false
      expect(contact_telephone.account_contact_id).to eq(contact.id)
    end
    # it "Shouldn't import phones twice" do 
    #   @importing.call
    #   expect{@importing.call}.to raise_error
    #   #expect{@importing.call}.to_not change{AccountContactTelephone.count}.by(1)
    # end
    it "Should import address data" do
      expect{@importing.call}.to change{AccountContactAddress.count}.by(1)
      contact = AccountContact.first
      contact_address = AccountContactAddress.first
      expect(contact_address.line_1).to eq("")
      expect(contact_address.line_2).to eq("")
      expect(contact_address.line_3).to eq("3558 Coldwater Canyon Ct.")
      expect(contact_address.zip).to eq("30084")
      expect(contact_address.city).to eq("Tucker")
      expect(contact_address.country).to eq("USA")
      expect(contact_address.account_contact_id).to eq(contact.id)
    end
    # it "Shouldn't import addresses twice" do 
    #   @importing.call
    #   expect{@importing.call}.to raise_error
    #   #expect{@importing.call}.to_not change{AccountContactAddress.count}.by(1)
    # end
  end
  end
end
