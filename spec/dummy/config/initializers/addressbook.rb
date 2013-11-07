require 'carrierwave'
CarrierWave.configure do |config|
  config.root = ::Rails.root.to_s+"/public/"
end

Addressbook.configure do
  
  def current_account
    User.first if ActiveRecord::Base.connection.table_exists? 'users'
  end

  @current_account = current_account

  def image_storing_path
  	return "uploads"
  end

end