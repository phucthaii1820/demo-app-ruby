def seed_categories
  hobby = [ 'Arts', 'Crafts', 'Sports' ]
  study = [ 'Economics and Finance', 'Business',
          'Social Sciences', 'Language' ]
  team = [ 'Study', 'Development' ]

  hobby.each do |name|
    Category.create(name: name)
  end

  study.each do |name|
    Category.create(name: name)
  end

  team.each do |name|
    Category.create(name: name)
  end
end

def seed_posts
  categories = Category.all

  categories.each do |category|
    5.times do
      Post.create(
        title: Faker::Lorem.sentences[0],
        content: Faker::Lorem.sentences[0],
        user_id: rand(1..9),
        category_id: category.id
      )
    end
  end
end

seed_categories
seed_posts
