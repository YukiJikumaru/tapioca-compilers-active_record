# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Tag`.
# Please instead update this file by running `bin/tapioca dsl Tag`.

class Tag
  include ::Tag::GeneratedAttributeMethods
  include ::Tag::GeneratedAssociationMethods
  include ::Tag::Internal__CustomFinderMethods
  extend GeneratedRelationMethods

  module ::Tag::GeneratedAssociationMethods
    sig { returns(::Tag::ActiveRecord_Associations_CollectionProxy) }
    def post_tag_relations; end

    sig { params(value: T::Enumerable[Tag]).returns(::Tag::ActiveRecord_Associations_CollectionProxy) }
    def post_tag_relations=(value); end

    sig { returns(T::Array[T.untyped]) }
    def post_tag_relations_ids; end

    sig { params(values: T::Enumerable[T.untyped]).returns(T::Array[T.untyped]) }
    def post_tag_relations_ids=(values); end

    sig { returns(::Tag::ActiveRecord_Associations_CollectionProxy) }
    def posts; end

    sig { params(value: T::Enumerable[Tag]).returns(::Tag::ActiveRecord_Associations_CollectionProxy) }
    def posts=(value); end

    sig { returns(T::Array[T.untyped]) }
    def posts_ids; end

    sig { params(values: T::Enumerable[T.untyped]).returns(T::Array[T.untyped]) }
    def posts_ids=(values); end
  end

  module ::Tag::GeneratedAttributeMethods
    sig { returns(T.untyped) }
    def clear_created_at_change; end

    sig { returns(T.untyped) }
    def clear_id_change; end

    sig { returns(T.untyped) }
    def clear_name_change; end

    sig { returns(T.untyped) }
    def clear_slug_change; end

    sig { returns(T.untyped) }
    def clear_updated_at_change; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def created_at; end

    sig { params(value: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
    def created_at=(value); end

    sig { returns(T::Boolean) }
    def created_at?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_before_last_save; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def created_at_before_type_cast; end

    sig { returns(T::Boolean) }
    def created_at_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def created_at_change; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.untyped])) }
    def created_at_change_to_be_saved; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def created_at_for_database; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def created_at_in_database; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def created_at_previous_change; end

    sig do
      params(
        from: T.nilable(::ActiveSupport::TimeWithZone),
        to: T.nilable(::ActiveSupport::TimeWithZone)
      ).returns(T::Boolean)
    end
    def created_at_previously_changed?(from: nil, to: nil); end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_previously_was; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def created_at_was; end

    sig { returns(T.untyped) }
    def created_at_will_change!; end

    sig { returns(T::Boolean) }
    def created_atchanged?; end

    sig { returns(::Integer) }
    def id; end

    sig { params(value: ::Integer).returns(::Integer) }
    def id=(value); end

    sig { returns(T::Boolean) }
    def id?; end

    sig { returns(T.nilable(::Integer)) }
    def id_before_last_save; end

    sig { returns(::Integer) }
    def id_before_type_cast; end

    sig { returns(T::Boolean) }
    def id_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def id_change; end

    sig { returns(T.nilable([T.nilable(::Integer), T.untyped])) }
    def id_change_to_be_saved; end

    sig { returns(::Integer) }
    def id_for_database; end

    sig { returns(::Integer) }
    def id_in_database; end

    sig { returns(T.nilable([T.nilable(::Integer), T.nilable(::Integer)])) }
    def id_previous_change; end

    sig { params(from: T.nilable(::Integer), to: T.nilable(::Integer)).returns(T::Boolean) }
    def id_previously_changed?(from: nil, to: nil); end

    sig { returns(T.nilable(::Integer)) }
    def id_previously_was; end

    sig { returns(T.nilable(::Integer)) }
    def id_was; end

    sig { returns(T.untyped) }
    def id_will_change!; end

    sig { returns(T::Boolean) }
    def idchanged?; end

    sig { returns(::String) }
    def name; end

    sig { params(value: ::String).returns(::String) }
    def name=(value); end

    sig { returns(T::Boolean) }
    def name?; end

    sig { returns(T.nilable(::String)) }
    def name_before_last_save; end

    sig { returns(::String) }
    def name_before_type_cast; end

    sig { returns(T::Boolean) }
    def name_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def name_change; end

    sig { returns(T.nilable([T.nilable(::String), T.untyped])) }
    def name_change_to_be_saved; end

    sig { returns(::String) }
    def name_for_database; end

    sig { returns(::String) }
    def name_in_database; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def name_previous_change; end

    sig { params(from: T.nilable(::String), to: T.nilable(::String)).returns(T::Boolean) }
    def name_previously_changed?(from: nil, to: nil); end

    sig { returns(T.nilable(::String)) }
    def name_previously_was; end

    sig { returns(T.nilable(::String)) }
    def name_was; end

    sig { returns(T.untyped) }
    def name_will_change!; end

    sig { returns(T::Boolean) }
    def namechanged?; end

    sig { returns(T.untyped) }
    def restore_created_at!; end

    sig { returns(T.untyped) }
    def restore_id!; end

    sig { returns(T.untyped) }
    def restore_name!; end

    sig { returns(T.untyped) }
    def restore_slug!; end

    sig { returns(T.untyped) }
    def restore_updated_at!; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), ::ActiveSupport::TimeWithZone])) }
    def saved_change_to_created_at; end

    sig { returns(T::Boolean) }
    def saved_change_to_created_at?; end

    sig { returns(T.nilable([T.nilable(::Integer), ::Integer])) }
    def saved_change_to_id; end

    sig { returns(T::Boolean) }
    def saved_change_to_id?; end

    sig { returns(T.nilable([T.nilable(::String), ::String])) }
    def saved_change_to_name; end

    sig { returns(T::Boolean) }
    def saved_change_to_name?; end

    sig { returns(T.nilable([T.nilable(::String), ::String])) }
    def saved_change_to_slug; end

    sig { returns(T::Boolean) }
    def saved_change_to_slug?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), ::ActiveSupport::TimeWithZone])) }
    def saved_change_to_updated_at; end

    sig { returns(T::Boolean) }
    def saved_change_to_updated_at?; end

    sig { returns(::String) }
    def slug; end

    sig { params(value: ::String).returns(::String) }
    def slug=(value); end

    sig { returns(T::Boolean) }
    def slug?; end

    sig { returns(T.nilable(::String)) }
    def slug_before_last_save; end

    sig { returns(::String) }
    def slug_before_type_cast; end

    sig { returns(T::Boolean) }
    def slug_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def slug_change; end

    sig { returns(T.nilable([T.nilable(::String), T.untyped])) }
    def slug_change_to_be_saved; end

    sig { returns(::String) }
    def slug_for_database; end

    sig { returns(::String) }
    def slug_in_database; end

    sig { returns(T.nilable([T.nilable(::String), T.nilable(::String)])) }
    def slug_previous_change; end

    sig { params(from: T.nilable(::String), to: T.nilable(::String)).returns(T::Boolean) }
    def slug_previously_changed?(from: nil, to: nil); end

    sig { returns(T.nilable(::String)) }
    def slug_previously_was; end

    sig { returns(T.nilable(::String)) }
    def slug_was; end

    sig { returns(T.untyped) }
    def slug_will_change!; end

    sig { returns(T::Boolean) }
    def slugchanged?; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def updated_at; end

    sig { params(value: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
    def updated_at=(value); end

    sig { returns(T::Boolean) }
    def updated_at?; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_before_last_save; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def updated_at_before_type_cast; end

    sig { returns(T::Boolean) }
    def updated_at_came_from_user?; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def updated_at_change; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.untyped])) }
    def updated_at_change_to_be_saved; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def updated_at_for_database; end

    sig { returns(::ActiveSupport::TimeWithZone) }
    def updated_at_in_database; end

    sig { returns(T.nilable([T.nilable(::ActiveSupport::TimeWithZone), T.nilable(::ActiveSupport::TimeWithZone)])) }
    def updated_at_previous_change; end

    sig do
      params(
        from: T.nilable(::ActiveSupport::TimeWithZone),
        to: T.nilable(::ActiveSupport::TimeWithZone)
      ).returns(T::Boolean)
    end
    def updated_at_previously_changed?(from: nil, to: nil); end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_previously_was; end

    sig { returns(T.nilable(::ActiveSupport::TimeWithZone)) }
    def updated_at_was; end

    sig { returns(T.untyped) }
    def updated_at_will_change!; end

    sig { returns(T::Boolean) }
    def updated_atchanged?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_created_at?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_id?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_name?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_slug?; end

    sig { returns(T::Boolean) }
    def will_save_change_to_updated_at?; end
  end

  module ::Tag::Internal__CustomFinderMethods; end

  class ActiveRecord_AssociationRelation < ::ActiveRecord::AssociationRelation
    include GeneratedRelationMethods
  end

  class ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
    include GeneratedRelationMethods
  end

  class ActiveRecord_DisableJoinsAssociationRelation < ::ActiveRecord::DisableJoinsAssociationRelation
    include GeneratedRelationMethods
  end

  class ActiveRecord_Relation < ::ActiveRecord::Relation
    include GeneratedRelationMethods
  end

  module GeneratedRelationMethods
    sig { params(other: ::ActiveRecord::Relation).returns(ActiveRecord_Relation) }
    def and(other); end

    sig { params(args: ::String).returns(ActiveRecord_Relation) }
    def annotate(*args); end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(::ActiveRecord::Promise) }
    def async_average(column_name); end

    sig { params(column_name: T.nilable(T.any(::String, ::Symbol))).returns(::ActiveRecord::Promise) }
    def async_count(column_name = nil); end

    sig { returns(::ActiveRecord::Promise) }
    def async_ids; end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(::ActiveRecord::Promise) }
    def async_maximum(column_name); end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(::ActiveRecord::Promise) }
    def async_minimum(column_name); end

    sig { params(column_names: T.any(::Symbol, ::String)).returns(::ActiveRecord::Promise) }
    def async_pick(*column_names); end

    sig { params(column_names: T.any(::Symbol, ::String)).returns(::ActiveRecord::Promise) }
    def async_pluck(*column_names); end

    sig { params(initial_value_or_column: T.any(::String, ::Symbol, ::Integer)).returns(::ActiveRecord::Promise) }
    def async_sum(initial_value_or_column = 0); end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(T.untyped) }
    def average(column_name); end

    sig { params(operation: ::Symbol, column_name: T.nilable(T.any(::String, ::Symbol))).returns(T.untyped) }
    def calculate(operation, column_name); end

    sig { params(column_name: T.nilable(T.any(::String, ::Symbol))).returns(::Integer) }
    def count(column_name = nil); end

    sig { params(other: T.untyped).returns(ActiveRecord_Relation) }
    def create_with(other); end

    sig { params(value: T::Boolean).returns(ActiveRecord_Relation) }
    def distinct(value = false); end

    sig do
      params(
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def eager_load(*args); end

    sig { params(skips: ::Symbol).returns(ActiveRecord_Relation) }
    def except(*skips); end

    sig { params(records: T::Enumerable[::ActiveRecord::Base]).returns(ActiveRecord_Relation) }
    def excluding(*records); end

    sig { params(args: T.untyped).returns(T::Boolean) }
    def exists?(args = :none); end

    sig { params(modules: ::Module, block: T.untyped).returns(ActiveRecord_Relation) }
    def extending(*modules, &block); end

    sig { params(association: ::Symbol).returns(T::Array[T.untyped]) }
    def extract_associated(association); end

    sig { returns(T.nilable(Tag)) }
    def fifth; end

    sig { returns(Tag) }
    def fifth!; end

    sig { params(args: T.untyped).returns(Tag) }
    def find(*args); end

    sig { params(arg: T.untyped, args: T.untyped).returns(T.nilable(Tag)) }
    def find_by(arg, *args); end

    sig { params(arg: T.untyped, args: T.untyped).returns(Tag) }
    def find_by!(arg, *args); end

    sig { params(arg: T.untyped, args: T.untyped).returns(Tag) }
    def find_sole_by(arg, *args); end

    sig { returns(T.nilable(Tag)) }
    def first; end

    sig { returns(Tag) }
    def first!; end

    sig { returns(T.nilable(Tag)) }
    def forty_two; end

    sig { returns(Tag) }
    def forty_two!; end

    sig { returns(T.nilable(Tag)) }
    def fourth; end

    sig { returns(Tag) }
    def fourth!; end

    sig { params(value: T.untyped, subquery_name: T.untyped).returns(ActiveRecord_Relation) }
    def from(value, subquery_name = nil); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def group(arg, *args); end

    sig { params(opts: ::String, rest: T.untyped).returns(ActiveRecord_Relation) }
    def having(opts, *rest); end

    sig { returns(T::Array[T.untyped]) }
    def ids; end

    sig { params(column: T.any(::String, ::Symbol), values: T.untyped).returns(ActiveRecord_Relation) }
    def in_order_of(column, values); end

    sig { params(record: T.nilable(Tag)).returns(T::Boolean) }
    def include?(record); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def includes(arg, *args); end

    sig { returns(ActiveRecord_Relation) }
    def invert_where; end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def joins(arg, *args); end

    sig { returns(T.nilable(Tag)) }
    def last; end

    sig { returns(Tag) }
    def last!; end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def left_joins(arg, *args); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def left_outer_joins(arg, *args); end

    sig { params(value: ::Integer).returns(ActiveRecord_Relation) }
    def limit(value); end

    sig { params(locks: T::Boolean).returns(ActiveRecord_Relation) }
    def lock(locks = true); end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(T.untyped) }
    def maximum(column_name); end

    sig { params(record: T.nilable(Tag)).returns(T::Boolean) }
    def member?(record); end

    sig { params(other: ::ActiveRecord::Relation, rest: ::ActiveRecord::Relation).returns(ActiveRecord_Relation) }
    def merge(other, *rest); end

    sig { params(column_name: T.any(::String, ::Symbol)).returns(T.untyped) }
    def minimum(column_name); end

    sig { returns(ActiveRecord_Relation) }
    def none; end

    sig { params(value: ::Integer).returns(ActiveRecord_Relation) }
    def offset(value); end

    sig { params(onlies: ::Symbol).returns(ActiveRecord_Relation) }
    def only(*onlies); end

    sig { params(args: ::String).returns(ActiveRecord_Relation) }
    def optimizer_hints(*args); end

    sig { params(other: ::ActiveRecord::Relation).returns(ActiveRecord_Relation) }
    def or(other); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])
      ).returns(ActiveRecord_Relation)
    end
    def order(arg, *args); end

    sig { params(column_names: T.any(::Symbol, ::String)).returns(T.untyped) }
    def pick(*column_names); end

    sig { params(column_names: T.any(::Symbol, ::String)).returns(T::Array[T.untyped]) }
    def pluck(*column_names); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def preload(arg, *args); end

    sig { params(locks: T::Boolean).returns(ActiveRecord_Relation) }
    def readonly(locks = true); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        table_names: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def references(arg, *table_names); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def regroup(arg, *args); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)]),
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])
      ).returns(ActiveRecord_Relation)
    end
    def reorder(arg, *args); end

    sig do
      params(
        arg: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        fields: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def reselect(arg, *fields); end

    sig { returns(ActiveRecord_Relation) }
    def reverse_order; end

    sig { params(conditions: T.untyped).returns(ActiveRecord_Relation) }
    def rewhere(conditions); end

    sig { returns(T.nilable(Tag)) }
    def second; end

    sig { returns(Tag) }
    def second!; end

    sig { returns(T.nilable(Tag)) }
    def second_to_last; end

    sig { returns(Tag) }
    def second_to_last!; end

    sig do
      params(
        field: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped]),
        fields: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def select(field, *fields); end

    sig { returns(Tag) }
    def sole; end

    sig { params(value: T::Boolean).returns(ActiveRecord_Relation) }
    def strict_loading(value = true); end

    sig { params(other: ::ActiveRecord::Relation).returns(T::Boolean) }
    def structurally_compatible?(other); end

    sig { params(initial_value_or_column: T.any(::String, ::Symbol, ::Integer)).returns(T.untyped) }
    def sum(initial_value_or_column = 0); end

    sig { params(limit: T.nilable(::Integer)).returns(T::Array[Tag]) }
    def take(limit = nil); end

    sig { returns(Tag) }
    def take!; end

    sig { returns(T.nilable(Tag)) }
    def third; end

    sig { returns(Tag) }
    def third!; end

    sig { returns(T.nilable(Tag)) }
    def third_to_last; end

    sig { returns(Tag) }
    def third_to_last!; end

    sig { params(name: T.untyped).returns(ActiveRecord_Relation) }
    def uniq!(name); end

    sig do
      params(
        args: T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])
      ).returns(ActiveRecord_Relation)
    end
    def unscope(*args); end

    sig { params(args: T.untyped).returns(ActiveRecord_Relation) }
    def where(*args); end

    sig do
      params(
        arg: T::Hash[T.untyped, T.untyped],
        args: T::Hash[T.untyped, T.untyped]
      ).returns(ActiveRecord_Relation)
    end
    def with(arg, *args); end

    sig { params(records: T::Enumerable[::ActiveRecord::Base]).returns(ActiveRecord_Relation) }
    def without(*records); end
  end
end
