ValidCard = Struct.new(:first_name, :last_name, :emails, :photo, :phone_numbers, :addresses)
class Parser
  def initialize(raw_vcards)
    @splitted_raw_cards = split_source_to_array_vcards(raw_vcards)
  end
  def split_source_to_array_vcards(raw_vcards)
    splitted_cards = Array.new
      vcard_data = ""
      raw_vcards.each_line do |line|
        vcard_data << line
        if line.include?("END:VCARD")
          if vcard_data != nil && vcard_data.length > 0
            splitted_cards << vcard_data
          end
          vcard_data = ""
        end
      end
      return splitted_cards
  end
  
  def get_contacts
    @splitted_raw_cards.map do |raw_card_data|
      parsed_card = VCardigan.parse(raw_card_data)
      ValidCard.new(
        get_first_name(parsed_card),
        get_last_name(parsed_card),
        get_emails(parsed_card),
        get_photo(raw_card_data),
        get_phone_numbers(parsed_card),
        get_addresses(parsed_card)
      )
    end
  end
 
  def get_first_name(parsed_card)
    get_name(:first, parsed_card)
  end
 
  def get_last_name(parsed_card)
    get_name(:last, parsed_card)
  end
 
  def get_name(type, parsed_card)
    names = {}
    if parsed_card.n.nil? || parsed_card.n.first.values[0].empty?
      if parsed_card.fn.nil? || parsed_card.fn.first.values[0].nil? || parsed_card.fn.first.values[0].empty?
        names[:first] = nil
        names[:last] = nil
      else
        names[:first] = parsed_card.fn.first.values[0].split(" ")[0]
        names[:last] = parsed_card.fn.first.values[0].split(" ")[1]
      end
    else
      names[:first] = parsed_card.n.first.values[1]
      names[:last] = parsed_card.n.first.values[0]
    end
    return names[type]
  end
 
  def get_emails(parsed_card)
    email_list = []
    if parsed_card.email
      parsed_card.email.each do |vcard_email|
        email_hash = Hash.new
        email_hash['address'] = vcard_email.value
        email_hash['preferred'] = vcard_email.params['preferred']
        email_list << email_hash
      end
    end
    return email_list
  end
 
  def get_phone_numbers(parsed_card)
    tel_list = []
    if parsed_card.tel 
      parsed_card.tel.each do |phone_n|
        tel_hash = Hash.new
        tel_hash['number'] = phone_n.value
        tel_hash['preferred'] = phone_n.params['preferred']
        tel_list << tel_hash
      end
    end
    return tel_list
  end

  def get_addresses(parsed_card)
    adr_list = []
     if parsed_card.adr
       parsed_card.adr.each do |address|
         adr_hash = Hash.new
         adr_hash["line_1"] = address.values[0]
         adr_hash["line_2"] = address.values[1]
         adr_hash["line_3"] = address.values[2]
         adr_hash["city"] =  address.values[3]
         adr_hash["zip"] = address.values[5]
         adr_hash["country"] = address.values[6]
         adr_hash['preferred'] = address.params['preferred']
         adr_list << adr_hash
       end
     end
    return adr_list
  end
   
  def get_photo raw_vcard
    photo_data_regex = /\/9j\/((.)+)+./omix
    is_binary = photo_data_regex.match(raw_vcard)
    picture_string = ""
    raw_vcard.each_line do |line|
      if photo_data_regex.match(line)
        photo_data_regex.match(line).to_s  
        picture_string << photo_data_regex.match(line).to_s
      end
      if line[0] == " " && is_binary
        picture_string << line
      end
    end
    
    if is_binary
      picture_string =  picture_string.delete(" ")
      picture = Base64.decode64(picture_string)
    end
    return picture
  end
end

class OutlookParser < Parser
  
  def initialize(raw_vcards)
    super
    remove_wrong_format(@splitted_raw_cards)
  end
  
  def remove_wrong_format(raw_vcards)
    raw_vcards.map! do |raw_vcard|
      # raw_vcard.each_line.to_a.delete_if{|line| line.include?("X-MS-OL-DESIGN")}.join
      raw_vcard.each_line.to_a.delete_if{|line| line[0..1] == "\n" || line[0..1] == "\r\n"}.join
    end
  end
end