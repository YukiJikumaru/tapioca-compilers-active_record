# typed: true
class TestController < ApplicationController
  extend T::Sig

  def index
    # NG
    x = TableOne.find(1)

    # TableOne::PrivateRelation
    x = TableOne.joins(:x)

    # NG
    TableOne.joins(:x).includes(:x).last
    TableOne.joins(:x).includes(:x).where(id: 1)
    aaa = TableOne.joins(:x).includes(:x).where(id: 1).limit(1).to_a

    Tag.where(id: 1).new
    Tag.where(id: 1).find_or_create_by({})

    ActiveRecord::Associations::CollectionProxy
    ActiveRecord::Batches::BatchEnumerator
    ActiveRecord::Promise

    Post.find(1)
    x = Post.find_or_create_by(id: 1) do |a|
      puts a
    end
    if x
      x.title_previously_changed?(from: nil)
      x.new_record?
    end

    ActiveRecord::Promise

    Post.create(1)

    x = Post.find(1)
    Post.includes(:a).with(a: 1)
    x = Post.find_by(id: 1)


    a = T.let(Post.new, Post)
    a.id_before_last_save


    Post.new
    Post.build
    Post.update(1, name: 'NEW NAME!!!')
    Post.update(name: 'NEW NAME!!!')
    Post.initialize_copy(Post)
    Post.where(id: 1).to_ary
    Post.where.encode_with({})
    Post.where.size
    Post.where.cache_key
    # WOW!!!!
    Post.where(id: 1).update(title: 'www')
    Post.where(id: 1).update(2, title: 'www')
    Post.where(author_id: 1).update_counters(comment_count: 1)


    # Post.and
    # Post.annotate
    Post.any?
    # Post.async_average(:id)
    # Post.async_count
    # Post.async_ids
    # Post.async_maximum(:id)
    # Post.async_minimum(:id)
    # Post.async_pick(:id)
    # Post.async_pluck(:id)
    # Post.async_sum(:id)
    # Post.average(:id)
    # Post.calculate(:sum, :id)
    # Post.count(:id)
    Post.create_or_find_by
    Post.create_or_find_by!
    # Post.create_with(locked: false)
    Post.delete_all
    Post.delete_by
    Post.destroy_all
    Post.destroy_by
    # Post.distinct
    # Post.eager_load(:tags)
    # Post.except(:title)
    # Post.excluding(Post.where(id: 1..2))
    Post.exists?
    # Post.extending
    # Post.extract_associated(:tags)
    # Post.fifth
    # Post.fifth!
    # Post.find
    # Post.find_by(id: 1)
    # Post.find_by!(id: 1)
    Post.find_each
    Post.find_in_batches
    Post.find_or_create_by
    Post.find_or_create_by!
    Post.find_or_initialize_by
    # Post.find_sole_by(id: 1)
    # Post.first
    # Post.first_or_create
    # Post.first_or_create!
    # Post.first_or_initialize
    # Post.first!
    # Post.forty_two
    # Post.forty_two!
    # Post.fourth
    # Post.fourth!
    # Post.from('posts')
    Post.group(:id)
    # Post.having('id = 1')
    # Post.ids
    Post.in_batches
    # Post.in_order_of(:id, [2, 1, 3])
    # Post.includes(:tags)
    # Post.invert_where
    # Post.joins(:tags)
    # Post.last
    # Post.last!
    # Post.left_joins(:tags)
    # Post.left_outer_joins(:tags)
    # Post.limit(1)
    # Post.lock
    # Post.many?
    # Post.maximum(:id)
    # Post.merge(Post.where(id: 1))
    # Post.minimum(:id)
    # Post.none
    Post.none?
    # Post.offset(1)
    Post.one?
    # Post.only
    # Post.optimizer_hints('')
    # Post.or(Post.where(id: 1)).where(id: 2)
    # Post.order(id: :asc)
    # Post.pick
    # Post.pluck
    # Post.preload(:tags)
    # Post.readonly
    # Post.references(:tags)
    # Post.regroup(:id)
    # Post.reorder(:id)
    # Post.reselect(:id)
    # Post.rewhere(id: 1)
    # Post.second
    # Post.second_to_last
    # Post.second_to_last!
    # Post.second!
    # Post.select(:id)
    # Post.where(id: 1).sole
    # Post.strict_loading
    # Post.sum(:id)
    # Post.take
    # Post.take!
    # Post.third
    # Post.third_to_last
    # Post.third_to_last!
    # Post.third!
    Post.touch_all(time: Time.zone.now)
    # Post.unscope(:joins)
    Post.update_all(name: 'x')
    Post.where
    # Post.with(posts_with_tags: Post.where("id > ?", 0))
    # Post.without
  end
end
