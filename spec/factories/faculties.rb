require 'faker'

##
# Factory for a faculty object
##
FactoryGirl.define do

  factory :faculty do

    name {Faker::Name.first_name}
    phone {Faker::PhoneNumber.phone_number}
    department {'department'}
    university {'university'}
    email {Faker::Internet.email}
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
    approved true

  end
end