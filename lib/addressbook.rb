require "addressbook/engine"
require 'select2-rails'
require 'kaminari'
module Addressbook
  def self.configure &block
    yield
  end
end
