class SessionsController < ApplicationController
  skip_before_action :authenticate_account!

  def new
    render layout: false
  end

  def create
    auth_params = params[:session] || {}
    @account = Account.find_by_email(auth_params[:email])
    if @account && @account.authenticate(auth_params[:password])
      session[:account_id] = @account.id
      redirect_to root_path
    else
      redirect_to account_login_url
    end
  end

  def destroy
    session[:account_id] = nil
    redirect_to account_login_url
  end
end
