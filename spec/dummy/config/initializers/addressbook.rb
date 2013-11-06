Addressbook.configure do
  
  def current_account
    User.first if ActiveRecord::Base.connection.table_exists? 'users'
  end

  @current_account = current_account
end