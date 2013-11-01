require 'vcardigan'
require 'base64'
require_relative "../lib/parser_factory"
require_relative "../lib/parser"
class ContactImporter
  
  attr_accessor :data
  
  def initialize(data)
    self.data = data
  end
  
  def parse
    parser = find_parser_class_by_data(data)
    parser.get_contacts
  end
  
  def find_parser_class_by_data(data)
    parser_class = ParserFactory.find_parser(data)
    parser = parser_class.new(data)
  end
end
class CarrierStringIO < StringIO
  def original_filename
    # the real name does not matter
    "photo.jpeg"
  end

  def content_type
    # this should reflect real content type, but for this example it's ok
    "image/jpeg"
  end
end