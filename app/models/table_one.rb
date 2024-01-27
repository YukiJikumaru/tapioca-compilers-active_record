# typed: true
#
# ```sql
# CREATE TABLE `table_ones` (
#   `id` bigint(20) NOT NULL AUTO_INCREMENT,
#   `string_non_null` varchar(255) NOT NULL,
#   `string_nullable` varchar(255) DEFAULT NULL,
#   `integer_non_null` int(11) NOT NULL,
#   `integer_nullable` int(11) DEFAULT NULL,
#   `created_at` datetime(6) NOT NULL,
#   `updated_at` datetime(6) NOT NULL,
#   PRIMARY KEY (`id`)
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
# ```
class TableOne < ApplicationRecord
  scope :test1, -> { where(id: 1) }
  scope :test2, -> { nil }
  scope :test3, -> { false }
  scope :test4, -> { [] }
  scope :test5, -> { :noooo }
  scope :test6, ->(arg1) { where(id: arg1) }
  scope :test7, ->(arg1, arg2) { where(id: arg1).or(where(id: arg2)) }


  class Hoge
    module Foo
      extend T::Sig
      sig { returns(T.self_type) }
      def aaa
        self
      end
    end
    class Spam
      include Foo

      def wow
        aaa
      end
    end
  end

  def self.assert_class_method
    fail('This code is just for type checking test, dont execute me!') if '🐕' != '🐈'

    T.assert_type!(self.===(1), FalseClass)
    # T.assert_type!(abstract_class?, T::Boolean)

    T.assert_type!(select(:id, :string_non_null, :string_nullable), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(select('`id`'), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(joins(:example), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(joins('example'), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(joins(hash: { example: :example }), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(left_joins(:example), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(left_outer_joins(:example), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(includes(:example), ::TableOne::ActiveRecord_Relation)
    T.assert_type!(eager_load(:example), ::TableOne::ActiveRecord_Relation)
  end

  def instance_method_tests
    fail('This code is just for type checking test, dont execute me!') if '🐕' != '🐈'

    ##### GeneratedAttributeMethods #####
    T.assert_type!(id, ::Integer)
    T.assert_type!(id_was, T.nilable(::Integer))
    T.assert_type!(string_non_null, ::String)
    T.assert_type!(string_nullable, T.nilable(::String))
    T.assert_type!(integer_non_null, ::Integer)
    T.assert_type!(integer_nullable, T.nilable(::Integer))
    T.assert_type!(created_at, ::ActiveSupport::TimeWithZone)
    T.assert_type!(updated_at, ::ActiveSupport::TimeWithZone)

    ##### ActiveRecord_Relation #####
    relation = TableOne.where(id: 0)
    T.assert_type!(relation, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.any?, T::Boolean)
    T.assert_type!(relation.blank?, T::Boolean)
    T.assert_type!(relation.build({}), ::TableOne)
    T.assert_type!(relation.build({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.cache_key, ::String)
    T.assert_type!(relation.cache_key(:last_reviewed_at), ::String)
    T.assert_type!(relation.cache_key_with_version, ::String)
    T.assert_type!(relation.cache_version(:last_reviewed_at), ::String)
    T.assert_type!(relation.create(), ::TableOne)
    T.assert_type!(relation.create({}), ::TableOne)
    T.assert_type!(relation.create({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.create!(), ::TableOne)
    T.assert_type!(relation.create!({}), ::TableOne)
    T.assert_type!(relation.create!({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.create_or_find_by({}), ::TableOne)
    T.assert_type!(relation.create_or_find_by({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.create_or_find_by!({}), ::TableOne)
    T.assert_type!(relation.create_or_find_by!({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
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
    T.assert_type!(relation.find_or_create_by({}), ::TableOne)
    T.assert_type!(relation.find_or_create_by({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.find_or_initialize_by({}), ::TableOne)
    T.assert_type!(relation.find_or_initialize_by({}) { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.has_limit_or_offset?, T::Boolean)
    T.assert_type!(relation.inspect, ::String)
    T.assert_type!(relation.joined_includes_values, T::Array[T.untyped])
    T.assert_type!(relation.klass, T::Class[::TableOne])
    T.assert_type!(relation.load, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.load_async, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.loaded, T::Boolean)
    T.assert_type!(relation.loaded?, T::Boolean)
    T.assert_type!(relation.locked?, T::Boolean)
    T.assert_type!(relation.many?, T::Boolean)
    T.assert_type!(relation.model, T::Class[::TableOne])
    T.assert_type!(relation.new, ::TableOne)
    T.assert_type!(relation.new { |arg| T.assert_type!(arg, ::TableOne) }, ::TableOne)
    T.assert_type!(relation.none, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.none?, T::Boolean)
    T.assert_type!(relation.one?, T::Boolean)
    relation.predicate_builder
    T.assert_type!(relation.preload_associations(relation), ::TableOne::ActiveRecord_Relation)
    relation.pretty_print(::PP)
    T.assert_type!(relation.records, T::Array[::TableOne])
    T.assert_type!(relation.reload, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.reset, ::TableOne::ActiveRecord_Relation)
    T.assert_type!(relation.scheduled?, T::Boolean)
    T.assert_type!(relation.scope_for_create, T::Hash[T.untyped, T.untyped])
    relation.scoping { 'HELLO' }
    T.assert_type!(relation.size, ::Integer)
    relation.skip_preloading_value
    relation.skip_preloading_value=('TEST')
    T.assert_type!(relation.table, ::Arel::Table)
    T.assert_type!(relation.to_a, T::Array[::TableOne])
    T.assert_type!(relation.to_ary, T::Array[::TableOne])
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
  end
end
