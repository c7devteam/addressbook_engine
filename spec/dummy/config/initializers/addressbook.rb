Addressbook.configure do
  
  def current_account
    User.first
  end

  @current_account = current_account
end