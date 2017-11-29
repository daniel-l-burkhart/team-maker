require 'faker'

##
# Factory that makes an admin object for testing
##
FactoryGirl.define do
  factory :administrator do

    name {Faker::Name.first_name}
    phone {Faker::PhoneNumber.phone_number}
    department {'department'}
    university {'university'}
    email {Faker::Internet.email}
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today

  end
end