# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: Post do
    content { Faker::Lorem.sentence }
  end
end
