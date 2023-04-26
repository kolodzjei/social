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

50.times do |n|
  Post.create(
    content: "This is post number #{n + 2} from the seed file!

      #{Faker::Lorem.paragraph(sentence_count: rand(2..23))}
    ",
    user_id: rand(1..10),
  )
end
