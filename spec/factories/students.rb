require 'faker'

##
# Factory for a student object
##
FactoryGirl.define do
  factory :student do

    name {Faker::Name.first_name}
    phone {Faker::PhoneNumber.phone_number}
    sequence(:student_id)
    university {'university'}
    email {Faker::Internet.email}
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today

  end
end