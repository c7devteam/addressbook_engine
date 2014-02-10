require "addressbook/engine"
require 'select2-rails'
require 'kaminari'
require "paranoia"
module Addressbook
  def self.configure &block
    yield
  end
end
