# frozen_string_literal: true

FactoryBot.define do
  factory :notification, class: Notification do
    content { Faker::Lorem.sentence }
  end
end
