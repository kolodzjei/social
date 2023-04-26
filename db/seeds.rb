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

15.times do |n|
  Post.create(
    content: "This is post number #{n + 2} from the seed file!

      #{Faker::Lorem.paragraph(sentence_count: rand(2..23))}
    ",
    user_id: rand(1..10),
  )
end

35.times do |n|
  Comment.create(
    content: "This is comment number #{n + 1} from the seed file!",
    user_id: rand(1..10),
    post_id: rand(1..16),
  )
end

100.times do |n|
  Reply.create(
    content: "This is reply number #{n + 1} from the seed file!",
    user_id: rand(1..10),
    comment_id: rand(1..35),
  )
end
