# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    content { "MyText" }
    user { nil }
    conversation { nil }
  end
end
