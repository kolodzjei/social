# frozen_string_literal: true

FactoryBot.define do
  factory :comment, class: Comment do
    content { Faker::Lorem.sentence }
  end
end
