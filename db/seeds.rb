# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


tag_japan = Tag.create!(name: '国内', slug: 'japan')
tag_world = Tag.create!(name: '国際', slug: 'world')
tag_politics = Tag.create!(name: '政治', slug: 'politics')
tag_science = Tag.create!(name: '科学', slug: 'science')
tag_sports = Tag.create!(name: 'スポーツ', slug: 'sports')
tag_business = Tag.create!(name: '経済', slug: 'business')

author1 = Author.create!(name: '筆者1', tel: '000-0000-0000', email: 'example1@example.com')
author2 = Author.create!(name: '筆者2', tel: '000-0000-0001', email: 'example2@example.com')
author3 = Author.create!(name: '筆者3', tel: '000-0000-0002', email: 'example3@example.com')

post1 = Post.create!(author: author1, title: 'タイトル1', content: '記事本文' * 10)
post2 = Post.create!(author: author2, title: 'タイトル2', content: '記事本文' * 10)
post3 = Post.create!(author: author3, title: 'タイトル3', content: '記事本文' * 10)
post4 = Post.create!(author: nil, title: 'タイトル4', content: '記事本文' * 10)

PostTagRelation.create!(post: post1, tag: tag_japan)
PostTagRelation.create!(post: post2, tag: tag_world)
PostTagRelation.create!(post: post3, tag: tag_sports)
PostTagRelation.create!(post: post3, tag: tag_business)
