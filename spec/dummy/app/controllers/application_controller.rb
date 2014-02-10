class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_account!
  helper_method :current_account, :account_logged_in?

  def current_account
    if session[:account_id]
      @current_account ||= Account.find(session[:account_id]) rescue nil
    end
  end

  def account_logged_in?
    !!current_account
  end

  def authenticate_account!
    redirect_to account_login_url unless account_logged_in?
  end
end
