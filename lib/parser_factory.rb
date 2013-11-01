module ParserFactory

  def self.find_parser data
    raise ArgumentError if data == ""
    if data.include?("X-MS-OL-DESIGN")
      return OutlookParser
    else
      return Parser
    end
  end
  
end