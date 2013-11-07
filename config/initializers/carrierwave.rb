require 'carrierwave'
CarrierWave.configure do |config|
  config.root = ::Rails.root.to_s + "/public"
end