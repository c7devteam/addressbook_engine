# Read about factories at https://github.com/thoughtbot/factory_girl
require "ffaker"
FactoryGirl.define do
  factory :account_contact do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    #image Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/rails.png'), 'image/png')
    before(:create){ ConfigEntry.stub(:get_val).with("CDN_STORAGE_PATH").and_return("development") }
  end
end
