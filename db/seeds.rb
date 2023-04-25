# frozen_string_literal: true

User.create(
  email: "user@example.com",
  password: "foobar",
  password_confirmation: "foobar",
)

9.times do |n|
  User.create(
    email: "user-#{n + 1}@example.com",
    password: "foobar",
    password_confirmation: "foobar",
  )
end

Post.create(
  content: "First post from the seed file!",
  user_id: 1,
)
