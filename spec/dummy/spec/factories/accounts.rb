# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    email "MyString"
    first_name "MyString"
    last_name "MyString"
    password_digest "MyString"
  end
end
