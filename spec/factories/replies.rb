# frozen_string_literal: true

FactoryBot.define do
  factory :reply do
    content { Faker::Lorem.sentence }
  end
end
