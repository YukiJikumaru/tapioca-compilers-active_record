# typed: true
#
# ```sql
# CREATE TABLE `authors` (
#   `id` bigint(20) NOT NULL AUTO_INCREMENT,
#   `name` varchar(255) NOT NULL COMMENT 'author''s name',
#   `tel` varchar(255) DEFAULT NULL COMMENT 'author''s telephone number',
#   `email` varchar(255) DEFAULT NULL COMMENT 'author''s email address',
#   `created_at` datetime(6) NOT NULL,
#   `updated_at` datetime(6) NOT NULL,
#   PRIMARY KEY (`id`)
# ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='authors'
# ```
class Author < ApplicationRecord
  has_many :posts

  scope :id_1, -> { where(id: 1) }
  scope :id_n, ->(n) { where(id: n) }

  def self.test_scope
    test_only!

    # @TODO parametersの定義 AST見ないと無理
    T.assert_type!(id_1, ::Author::ActiveRecord_Relation)
    T.assert_type!(id_n, ::Author::ActiveRecord_Relation)
  end

  def test_generated_attribute_methods
    test_only!

    T.assert_type!(id, ::Integer)
    T.assert_type!(id_was, T.nilable(::Integer))
    T.assert_type!(name, ::String)
    T.assert_type!(tel, T.nilable(::String))
    T.assert_type!(email, T.nilable(::String))
    T.assert_type!(created_at, ::ActiveSupport::TimeWithZone)
    T.assert_type!(updated_at, ::ActiveSupport::TimeWithZone)
  end

  def test_has_many_associations
    test_only!

    T.assert_type!(posts, ::Post::ActiveRecord_Associations_CollectionProxy)
    T.assert_type!(posts.where(id: 0), ::Post::ActiveRecord_Relation)
  end

  def test_relation_methods
    test_only!

    ##### ActiveRecord_Relation #####
    relation = Author.where(id: 0)
    T.assert_type!(relation, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.any?, T::Boolean)
    T.assert_type!(relation.blank?, T::Boolean)
    T.assert_type!(relation.build({}), ::Author)
    T.assert_type!(relation.build({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.cache_key, ::String)
    T.assert_type!(relation.cache_key(:last_reviewed_at), ::String)
    T.assert_type!(relation.cache_key_with_version, ::String)
    T.assert_type!(relation.cache_version(:last_reviewed_at), ::String)
    T.assert_type!(relation.create(), ::Author)
    T.assert_type!(relation.create({}), ::Author)
    T.assert_type!(relation.create({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.create!(), ::Author)
    T.assert_type!(relation.create!({}), ::Author)
    T.assert_type!(relation.create!({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.create_or_find_by({}), ::Author)
    T.assert_type!(relation.create_or_find_by({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.create_or_find_by!({}), ::Author)
    T.assert_type!(relation.create_or_find_by!({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    relation.delete_all
    relation.delete_by(id: 1)
    relation.delete_by('published_at < ?', 2.weeks.ago)
    relation.destroy_all
    relation.destroy_by(id: 1)
    relation.destroy_by('published_at < ?', 2.weeks.ago)
    T.assert_type!(relation.eager_loading?, T::Boolean)
    T.assert_type!(relation.empty?, T::Boolean)
    T.assert_type!(relation.empty_scope?, T::Boolean)
    relation.encode_with(::Psych::Coder.new('i_am_coder'))
    T.assert_type!(relation.explain, ::String)
    T.assert_type!(relation.explain(:analyze), ::String)
    T.assert_type!(relation.explain(:analyze, :verbose), ::String)
    T.assert_type!(relation.find_or_create_by({}), ::Author)
    T.assert_type!(relation.find_or_create_by({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.find_each, T::Enumerator[::Author])
    T.assert_type!(relation.find_in_batches, T::Enumerator[::Author])
    T.assert_type!(relation.find_or_initialize_by({}), ::Author)
    T.assert_type!(relation.find_or_initialize_by({}) { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.has_limit_or_offset?, T::Boolean)
    T.assert_type!(relation.in_batches, ::ActiveRecord::Batches::BatchEnumerator)
    # T.assert_type!(relation.in_batches, ::ActiveRecord::Batches::BatchEnumerator[::Author])
    T.assert_type!(relation.inspect, ::String)
    T.assert_type!(relation.joined_includes_values, T::Array[T.untyped])
    T.assert_type!(relation.klass, T::Class[::Author])
    T.assert_type!(relation.load, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.load_async, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.loaded, T::Boolean)
    T.assert_type!(relation.loaded?, T::Boolean)
    T.assert_type!(relation.locked?, T::Boolean)
    T.assert_type!(relation.many?, T::Boolean)
    T.assert_type!(relation.model, T::Class[::Author])
    T.assert_type!(relation.new, ::Author)
    T.assert_type!(relation.new { |arg| T.assert_type!(arg, ::Author) }, ::Author)
    T.assert_type!(relation.none, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.none?, T::Boolean)
    T.assert_type!(relation.one?, T::Boolean)
    relation.predicate_builder
    T.assert_type!(relation.preload_associations(relation), ::Author::ActiveRecord_Relation)
    relation.pretty_print(::PP)
    T.assert_type!(relation.records, T::Array[::Author])
    T.assert_type!(relation.reload, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.reset, ::Author::ActiveRecord_Relation)
    T.assert_type!(relation.scheduled?, T::Boolean)
    T.assert_type!(relation.scope_for_create, T::Hash[T.untyped, T.untyped])
    relation.scoping { 'HELLO' }
    T.assert_type!(relation.size, ::Integer)
    relation.skip_preloading_value
    relation.skip_preloading_value=('TEST')
    T.assert_type!(relation.table, ::Arel::Table)
    T.assert_type!(relation.to_a, T::Array[::Author])
    T.assert_type!(relation.to_ary, T::Array[::Author])
    T.assert_type!(relation.to_sql, ::String)
    relation.touch_all
    relation.touch_all(:created_at)
    relation.touch_all(time: Time.new(2020, 5, 16, 0, 0, 0))
    relation.update(name: 'NEW')
    relation.update(1, name: 'NEW')
    relation.update!(name: 'NEW')
    relation.update!(1, name: 'NEW')
    relation.update_all(author: 'David')
    relation.update_all('number = id')
    relation.update_all(title: ::Arel.sql("title + ' - volume 1'"))
    relation.update_counters(comment_count: 1)
    T.assert_type!(relation.values, T::Hash[T.untyped, T.untyped])
    T.assert_type!(relation.values_for_queries, T::Hash[T.untyped, T.untyped])
    T.assert_type!(relation.where_values_hash, T::Hash[T.untyped, T.untyped])
    T.assert_type!(relation.where_values_hash(:relation_table_name), T::Hash[T.untyped, T.untyped])

    # @TDODO enumerable
    x = relation[0]
    relation.first
    relation.each { |x| x }
    relation.map { |x| x }
  end
end
