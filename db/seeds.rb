# frozen_string_literal: true

User.create(
  email: "user@example.com",
  password: "foobar",
  password_confirmation: "foobar",
)

9.times do |n|
  u = User.new(
    email: "user-#{n + 1}@example.com",
    password: "foobar",
    password_confirmation: "foobar",
  )
  u.avatar.attach(
    io: File.open(
      Rails.root.join(
        "app", "assets", "images", "mockup_avatars", "#{n + 1}.jpg"
      ),
    ),
    filename: "#{n}.png",
    content_type: "image/jpg",
  )
  u.display_name = Faker::Name.first_name
  u.save
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
