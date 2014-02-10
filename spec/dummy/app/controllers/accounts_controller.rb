class AccountsController < ApplicationController
  layout "landing"
  skip_before_action :authenticate_account!

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      session[:account_id] = @account.id
      flash[:success] = "Successfully logged in"
      redirect_to root_path
    else
      flash[:danger] = @account.errors.full_messages.to_sentence
      redirect_to account_register_path
    end
  end

  def account_params
    params.require(:account).permit(:email, :first_name, :last_name,
                                    :password, :password_confirmation)
  end
end
