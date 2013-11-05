require "addressbook/engine"

module Addressbook
  def self.configure &block
    yield
  end
end
