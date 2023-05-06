# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    display_name { Faker::Name.name[0..14] }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
