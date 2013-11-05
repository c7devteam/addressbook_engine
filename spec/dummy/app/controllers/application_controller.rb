class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :filter_current_account
  def filter_current_account
    @current_account = current_account
  end
end
