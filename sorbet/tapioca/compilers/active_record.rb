# typed: true

begin
  require 'active_record'
rescue LoadError
  return
end

module Tapioca
  module Compilers
    class ActiveRecord < Tapioca::Dsl::Compiler
      extend T::Sig

      T_SELF = 'T.self_type'
      T_UNTYPED = 'T.untyped'
      T_BOOLEAN = 'T::Boolean'
      T_ATTACHED = 'T.attached_class'
      # @TODO 主キーの型をテーブルから導出する
      TODO_PRIMARY_KEY = T_UNTYPED

      ACTIVERECORD_RELATION_NAME = 'ActiveRecord_Relation'
      GENERATED_RELATION_METHODS_NAME = 'GeneratedRelationMethods'

      ConstantType = type_member {{ fixed: ::T.class_of(::ActiveRecord::Base) }}

      sig { params(pipeline: Tapioca::Dsl::Pipeline, root: RBI::Tree, constant: ConstantType).void }
      def initialize(pipeline, root, constant)
        super
      end

      sig { params(type: ::String).returns(::String) }
      def as_array(type)
        "T::Array[#{type}]"
      end

      sig { params(types: ::String).returns(::String) }
      def as_any(*types)
        return T_UNTYPED if types.any? { |t| t.match?(/\A(::)?T\.untyped\z/) }
        "T.any(#{types.join(', ')})"
      end

      def generate_primary_key_type(activerecord_model)
        attribute_types = activerecord_model.attribute_types
        if activerecord_model.composite_primary_key?
          types = activerecord_model.primary_key.map { |pk| type_for_activerecord_value(attribute_types[pk]) }
          "[#{types.join(', ')}]"
        else
          type_for_activerecord_value(attribute_types[activerecord_model.primary_key])
        end
      end


      sig { override.returns(::T::Enumerable[Module]) }
      def self.gather_constants
        ::ActiveRecord::Base.descendants.reject(&:abstract_class?)
      end

      sig { override.void }
      def decorate
        activerecord_model = constant
        root.create_path(activerecord_model) do |rbi_scope|
          # class Post < ::ApplicationRecord
          #   include Post::GeneratedAttributeMethods
          #   include Post::GeneratedAssociationMethods
          #   extend Post::QueryMethodsReturningRelation

          # class Post::ActiveRecord_Relation < ::ActiveRecord::Relation
          #   include Post::ActiveRelation_WhereNot
          #   include Post::QueryMethodsReturningRelation

          # class Post::ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
          #   include Post::QueryMethodsReturningAssociationRelation

          # class Post::ActiveRecord_AssociationRelation < ::ActiveRecord::AssociationRelation
          #   include Post::ActiveRelation_WhereNot
          #   include Post::QueryMethodsReturningAssociationRelation

          # class Post::ActiveRecord_DisableJoinsAssociationRelation < ::ActiveRecord::DisableJoinsAssociationRelation
          #   include Post::ActiveRelation_WhereNot
          #   include Post::QueryMethodsReturningAssociationRelation

          pk_type = generate_primary_key_type(activerecord_model)
          puts "pk_type = #{pk_type}"

          populate_querying_class_method(rbi_scope)
          populate_persistent_class_methods(rbi_scope)

          create_include_generated_attribute_methods_module(rbi_scope, activerecord_model)
          create_include_generated_association_methods_module(rbi_scope, activerecord_model)

          generated_relation_methods_module = create_generated_relation_methods_module(rbi_scope, activerecord_model)
          rbi_scope.create_extend(generated_relation_methods_module.fully_qualified_name)

          create_active_record_relation(rbi_scope, activerecord_model)

          create_active_record_associations_collection_proxy(rbi_scope)
          create_active_record_association_relation(rbi_scope)
          create_active_record_disable_joins_association_relation(rbi_scope)
        end
      end

      # activerecord-7.1.1/lib/active_record/querying.rb
      sig { params(rbi_scope: ::RBI::Scope).void }
      def populate_querying_class_method(rbi_scope)
        model_name = rbi_scope.fully_qualified_name

        # activerecord-7.1.1/lib/active_record/relation/finder_methods.rb
        # delegate to Model.all
        rbi_scope.create_method('find', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method('find_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('find_by!', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method('take', parameters: [create_opt_param('limit', type: as_nilable_type('::Integer'), default: 'nil')], return_type: as_array(model_name), class_method: true)
        rbi_scope.create_method('take!', return_type: model_name, class_method: true)
        rbi_scope.create_method('sole', return_type: model_name, class_method: true)
        rbi_scope.create_method('find_sole_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('first!', return_type: model_name, class_method: true)
        rbi_scope.create_method('last', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('last!', return_type: model_name, class_method: true)
        rbi_scope.create_method('second', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('second!', return_type: model_name, class_method: true)
        rbi_scope.create_method('third', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('third!', return_type: model_name, class_method: true)
        rbi_scope.create_method('fourth', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('fourth!', return_type: model_name, class_method: true)
        rbi_scope.create_method('fifth', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('fifth!', return_type: model_name, class_method: true)
        rbi_scope.create_method('forty_two', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('forty_two!', return_type: model_name, class_method: true)
        rbi_scope.create_method('third_to_last', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('third_to_last!', return_type: model_name, class_method: true)
        rbi_scope.create_method('second_to_last', return_type: as_nilable_type(model_name), class_method: true)
        rbi_scope.create_method('second_to_last!', return_type: model_name, class_method: true)
        rbi_scope.create_method('exists?', parameters: [create_opt_param('args', type: T_UNTYPED, default: ':none')], return_type: T_BOOLEAN, class_method: true)

        # activerecord-7.1.1/lib/active_record/relation.rb
        rbi_scope.create_method('any?', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_BOOLEAN, class_method: true)
        rbi_scope.create_method('many?', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_BOOLEAN, class_method: true)
        rbi_scope.create_method('none?', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_BOOLEAN, class_method: true)
        rbi_scope.create_method('one?', return_type: T_BOOLEAN, class_method: true)
        nilable_proc_type = as_nilable_type("T.proc.params(arg: #{model_name}).void")
        rbi_scope.create_method('first_or_create', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first_or_create!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first_or_initialize', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first_or_create', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first_or_create!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('first_or_initialize', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('find_or_create_by', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('find_or_create_by!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('find_or_initialize_by', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('create_or_find_by', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('create_or_find_by!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: nilable_proc_type)], return_type: model_name, class_method: true)
        rbi_scope.create_method('destroy_all', class_method: true)
        rbi_scope.create_method('delete_all', class_method: true)
        rbi_scope.create_method('update_all', parameters: [create_param('updates', type: T_UNTYPED)], class_method: true)
        rbi_scope.create_method('touch_all', parameters: [create_rest_param('names', type: T_UNTYPED), create_kw_opt_param('time', type: as_nilable_type('Time'), default: 'nil')], class_method: true)
        rbi_scope.create_method('destroy_by', parameters: [create_rest_param('args', type: T_UNTYPED)], class_method: true)
        rbi_scope.create_method('delete_by', parameters: [create_rest_param('args', type: T_UNTYPED)], class_method: true)

        # activerecord-7.1.1/lib/active_record/relation/batches.rb
        rbi_scope.create_method(
          'find_each',
          parameters: [
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('batch_size', type: 'Integer', default: '1000'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: "T::Enumerator[#{model_name}]",
          class_method: true,
        )
        rbi_scope.create_method(
          'find_in_batches',
          parameters: [
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('batch_size', type: 'Integer', default: '1000'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: "T::Enumerator[#{model_name}]",
          class_method: true,
        )
        rbi_scope.create_method(
          'in_batches',
          parameters: [
            create_kw_opt_param('of', type: 'Integer', default: '1000'),
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('load', type: T_BOOLEAN, default: 'false'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_kw_opt_param('use_ranges', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: "T::Enumerator[#{model_name}]", # @TODO ActiveRecord::Batches::BatchEnumerator
          class_method: true,
        )

        # activerecord-7.1.1/lib/active_record/relation/query_methods.rb
        common_type = 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])'
        relation_type = "#{model_name}::#{ACTIVERECORD_RELATION_NAME}"
        rbi_scope.create_method('select', parameters: [create_param('field', type: common_type), create_rest_param('fields', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('reselect', parameters: [create_param('arg', type: common_type), create_rest_param('fields', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('order', parameters: [create_param('arg', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])'), create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('regroup', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('in_order_of', parameters: [create_param('column', type: as_any('::String', '::Symbol')), create_param('values', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('reorder', parameters: [create_param('arg', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])'), create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('group', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('limit', parameters: [create_param('value', type: '::Integer')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('offset', parameters: [create_param('value', type: '::Integer')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('left_joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('left_outer_joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        # If no argument is passed, where returns a new instance of WhereChain, that can be chained with WhereChain#not, WhereChain#missing, or WhereChain#associated.
        rbi_scope.create_method('where', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('rewhere', parameters: [create_param('conditions', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('invert_where', return_type: relation_type, class_method: true)
        rbi_scope.create_method('preload', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('extract_associated', parameters: [create_param('association', type: '::Symbol')], return_type: as_array(T_UNTYPED), class_method: true)
        rbi_scope.create_method('eager_load', parameters: [create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('includes', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('from', parameters: [create_param('value', type: T_UNTYPED), create_opt_param('subquery_name', type: T_UNTYPED, default: 'nil')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('lock', parameters: [create_opt_param('locks', type: T_BOOLEAN, default: 'true')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('readonly', parameters: [create_opt_param('locks', type: T_BOOLEAN, default: 'true')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('and', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('or', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('annotate', parameters: [create_rest_param('args', type: '::String')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('optimizer_hints', parameters: [create_rest_param('args', type: '::String')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('extending', parameters: [create_rest_param('modules', type: '::Module'), create_block_param('block', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('having', parameters: [create_param('opts', type: '::String'), create_rest_param('rest', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('create_with', parameters: [create_param('other', type: T_UNTYPED)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('distinct', parameters: [create_opt_param('value', type: T_BOOLEAN, default: 'false')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('references', parameters: [create_param('arg', type: common_type), create_rest_param('table_names', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('none', return_type: relation_type, class_method: true)
        rbi_scope.create_method('unscope', parameters: [create_rest_param('args', type: common_type)], return_type: relation_type, class_method: true)
        rbi_scope.create_method('strict_loading', parameters: [create_opt_param('value', type: T_BOOLEAN, default: 'true')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('excluding', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('without', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('with', parameters: [create_param('arg', type: 'T::Hash[T.untyped, T.untyped]'), create_rest_param('args', type: 'T::Hash[T.untyped, T.untyped]')], return_type: relation_type, class_method: true)

        # activerecord-7.1.1/lib/active_record/relation/calculations.rb
        str_symbol = as_any('::String', '::Symbol')
        rbi_scope.create_method('count', parameters: [create_opt_param('column_name', type: as_nilable_type(str_symbol), default: 'nil')], return_type: '::Integer', class_method: true)
        rbi_scope.create_method('async_count', parameters: [create_opt_param('column_name', type: as_nilable_type(str_symbol), default: 'nil')], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('average', parameters: [create_param('column_name', type: str_symbol)], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('async_average', parameters: [create_param('column_name', type: str_symbol)], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('minimum', parameters: [create_param('column_name', type: str_symbol)], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('async_minimum', parameters: [create_param('column_name', type: str_symbol)], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('maximum', parameters: [create_param('column_name', type: str_symbol)], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('async_maximum', parameters: [create_param('column_name', type: str_symbol)], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('async_sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('calculate', parameters: [create_param('operation', type: '::Symbol'), create_param('column_name', type: as_nilable_type(str_symbol))], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('pluck', parameters: [create_rest_param('column_names', type: str_symbol)], return_type: as_array(T_UNTYPED), class_method: true)
        rbi_scope.create_method('async_pluck', parameters: [create_rest_param('column_names', type: str_symbol)], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('pick', parameters: [create_rest_param('column_names', type: str_symbol)], return_type: T_UNTYPED, class_method: true)
        rbi_scope.create_method('async_pick', parameters: [create_rest_param('column_names', type: str_symbol)], return_type: '::ActiveRecord::Promise', class_method: true)
        rbi_scope.create_method('ids', return_type: as_array(T_UNTYPED), class_method: true)
        rbi_scope.create_method('async_ids', return_type: '::ActiveRecord::Promise', class_method: true)

        # activerecord-7.1.1/lib/active_record/relation/spawn_methods.rb
        rbi_scope.create_method('merge', parameters: [create_param('other', type: '::ActiveRecord::Relation'), create_rest_param('rest', type: '::ActiveRecord::Relation')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('except', parameters: [create_rest_param('skips', type: '::Symbol')], return_type: relation_type, class_method: true)
        rbi_scope.create_method('only', parameters: [create_rest_param('onlies', type: '::Symbol')], return_type: relation_type, class_method: true)

        # activerecord-7.1.1/lib/active_record/querying.rb
        rbi_scope.create_method(
          'find_by_sql',
          parameters: [
            create_param('sql', type: T_UNTYPED),
            create_opt_param('binds', type: T_UNTYPED, default: '[]'),
            create_kw_opt_param('preparable', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_block_param('block', type: T_UNTYPED),
          ],
          return_type: "T::Array[#{model_name}]",
          class_method: true,
        )
        rbi_scope.create_method(
          'async_find_by_sql',
          parameters: [
            create_param('sql', type: T_UNTYPED),
            create_opt_param('binds', type: T_UNTYPED, default: '[]'),
            create_kw_opt_param('preparable', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_block_param('block', type: T_UNTYPED),
          ],
          return_type: '::ActiveRecord::Promise',
          class_method: true,
        )
        rbi_scope.create_method('count_by_sql', parameters: [create_param('sql', type: 'String')], return_type: '::Integer', class_method: true)
        rbi_scope.create_method('async_count_by_sql', parameters: [create_param('sql', type: 'String')], return_type: '::ActiveRecord::Promise', class_method: true)
      end

      # module Post::GeneratedAttributeMethods
      sig { params(rbi_scope: ::RBI::Scope, activerecord_model: ConstantType).void }
      def create_include_generated_attribute_methods_module(rbi_scope, activerecord_model)
        model_name = rbi_scope.fully_qualified_name

        generated_attribute_methods = rbi_scope.create_module("#{model_name}::GeneratedAttributeMethods")
        rbi_scope.create_include("#{model_name}::GeneratedAttributeMethods")

        attribute_aliases_map = activerecord_model.attribute_aliases.invert

        # @TODO attribute で宣言された動的カラム
        attributes_to_define_after_schema_loads = activerecord_model.attributes_to_define_after_schema_loads

        if activerecord_model.composite_primary_key?
          generated_attribute_methods.create_method('id', return_type: generate_primary_key_type(activerecord_model))
        end

        activerecord_model.columns.each do |column|
          column_name = column.name
          nullable = column.null
          comments = column.comment.nil? ? [] : [RBI::Comment.new(column.comment)]

          active_model_type = activerecord_model.attribute_types[column_name] # ActiveModel::Type::Value
          original_column_type = type_for_activerecord_value(active_model_type)
          nilable_column_type = as_nilable_type(original_column_type)
          column_type = nullable ? nilable_column_type : original_column_type

          # @TODO attribute_aliases の定義
          attribute_alias = attribute_aliases_map[column_name]

          # ActiveModel::AttributeMethods activemodel-7.1.1/lib/active_model/attribute_methods.rb
          # ------------------------------
          # %s
          generated_attribute_methods.create_method(column_name, return_type: column_type, comments: comments)
          # %s=
          generated_attribute_methods.create_method("#{column_name}=", parameters: [create_param('value', type: column_type)], return_type: column_type, comments: comments)
          # %s?
          generated_attribute_methods.create_method("#{column_name}?", return_type: T_BOOLEAN)

          # ActiveRecord::AttributeMethods::Dirty activerecord-7.1.1/lib/active_record/attribute_methods/dirty.rb
          # ------------------------------
          # saved_change_to_%s?
          generated_attribute_methods.create_method("saved_change_to_#{column_name}?", return_type: T_BOOLEAN)
          # saved_change_to_%s
          generated_attribute_methods.create_method("saved_change_to_#{column_name}", return_type: as_nilable_type("[#{nilable_column_type}, #{column_type}]"))
          # %s_before_last_save
          generated_attribute_methods.create_method("#{column_name}_before_last_save", return_type: nilable_column_type)
          # will_save_change_to_%s?
          generated_attribute_methods.create_method("will_save_change_to_#{column_name}?", return_type: T_BOOLEAN)
          # %s_change_to_be_saved
          generated_attribute_methods.create_method("#{column_name}_change_to_be_saved", return_type: as_nilable_type("[#{nilable_column_type}, T.untyped]"))
          # %s_in_database
          generated_attribute_methods.create_method("#{column_name}_in_database", return_type: column_type)

          # ActiveModel::Dirty activemodel-7.1.1/lib/active_model/dirty.rb
          # ------------------------------
          # %s_previously_changed?
          generated_attribute_methods.create_method("#{column_name}_previously_changed?", parameters: [create_kw_opt_param('from', type: nilable_column_type, default: 'nil'), create_kw_opt_param('to', type: nilable_column_type, default: 'nil')], return_type: T_BOOLEAN)
          # %s_changed?
          generated_attribute_methods.create_method("#{column_name}changed?", return_type: T_BOOLEAN)
          # %s_change
          generated_attribute_methods.create_method("#{column_name}_change", return_type: as_nilable_type("[#{nilable_column_type}, #{nilable_column_type}]"))
          # %s_will_change!
          generated_attribute_methods.create_method("#{column_name}_will_change!")
          # %s_was
          generated_attribute_methods.create_method("#{column_name}_was", return_type: nilable_column_type)
          # %s_previous_change
          generated_attribute_methods.create_method("#{column_name}_previous_change", return_type: as_nilable_type("[#{nilable_column_type}, #{nilable_column_type}]"))
          # %s_previously_was
          generated_attribute_methods.create_method("#{column_name}_previously_was", return_type: nilable_column_type)
          # restore_%s!
          generated_attribute_methods.create_method("restore_#{column_name}!")
          # clear_%s_change
          generated_attribute_methods.create_method("clear_#{column_name}_change")

          # ActiveRecord::AttributeMethods::BeforeTypeCast activerecord-7.1.1/lib/active_record/attribute_methods/before_type_cast.rb
          # ------------------------------
          # @TODO enumの場合は異なる それ以外は？
          # %s_before_type_cast
          generated_attribute_methods.create_method("#{column_name}_before_type_cast", return_type: column_type)
          # @TODO enumの場合は異なる それ以外は？
          # %s_for_database
          generated_attribute_methods.create_method("#{column_name}_for_database", return_type: column_type)
          # %s_came_from_user?
          generated_attribute_methods.create_method("#{column_name}_came_from_user?", return_type: T_BOOLEAN)
        end
      end

      # module Post::GeneratedAssociationMethods
      sig { params(rbi_scope: ::RBI::Scope, activerecord_model: ConstantType).void }
      def create_include_generated_association_methods_module(rbi_scope, activerecord_model)
        model_name = rbi_scope.fully_qualified_name
        generated_association_methods = rbi_scope.create_module("#{model_name}::GeneratedAssociationMethods")
        rbi_scope.create_include("#{model_name}::GeneratedAssociationMethods")
        activerecord_associations_collection_proxy_name = "#{model_name}::ActiveRecord_Associations_CollectionProxy"

        activerecord_model.reflections.each do |association_name, reflection|
          optional = reflection.options[:optional]
          reflection_name = reflection.name
          original_reflection_type = reflection.active_record.name
          reflection_type = optional ? as_nilable_type(original_reflection_type) : original_reflection_type

          if reflection.collection?
            # @TODO xxx_ids, xxx_ids=を型付け
            # if reflection.foreign_key
            #   reflection.active_record.columns_hash.fetch(reflection.foreign_key)
            # else
            #   reflection.active_record.columns_hash.fetch(reflection.foreign_key)
            # end
            # %s
            generated_association_methods.create_method(reflection_name, return_type: activerecord_associations_collection_proxy_name)
            # %s=
            generated_association_methods.create_method("#{reflection_name}=", parameters: [create_param('value', type: "T::Enumerable[#{original_reflection_type}]")], return_type: activerecord_associations_collection_proxy_name)
            # %s_ids
            generated_association_methods.create_method("#{reflection_name}_ids", return_type: 'T::Array[T.untyped]')
            # %s_ids=
            generated_association_methods.create_method("#{reflection_name}_ids=", parameters: [create_param('values', type: "T::Enumerable[T.untyped]")], return_type: 'T::Array[T.untyped]')
          else
            # %s
            generated_association_methods.create_method(reflection_name, return_type: reflection_type)
            # %s=
            generated_association_methods.create_method("#{reflection_name}=", parameters: [create_param('value', type: reflection_type)], return_type: reflection_type)
            # reload_%s
            generated_association_methods.create_method("reload_#{reflection_name}", return_type: reflection_type)

            # [Association Extensions](https://guides.rubyonrails.org/association_basics.html#association-extensions)はサポートできず
            unless reflection.polymorphic?
              # build_%s
              generated_association_methods.create_method(
                "build_#{reflection_name}",
                parameters: [
                  create_opt_param('value', type: 'T::Hash[T.untyped, T.untyped]', default: '{}'),
                  create_block_param('blk', type: "T.proc.bind(#{original_reflection_type}).params(arg: #{original_reflection_type}).void"),
                ],
                return_type: original_reflection_type,
              )
              # create_%s
              generated_association_methods.create_method(
                "create_#{reflection_name}",
                parameters: [
                  create_opt_param('value', type: 'T::Hash[T.untyped, T.untyped]', default: '{}'),
                  create_block_param('blk', type: "T.proc.bind(#{original_reflection_type}).params(arg: #{original_reflection_type}).void"),
                ],
                return_type: reflection_type,
              )
              # create_%s!
              generated_association_methods.create_method(
                "create_#{reflection_name}!",
                parameters: [
                  create_opt_param('value', type: 'T::Hash[T.untyped, T.untyped]', default: '{}'),
                  create_block_param('blk', type: "T.proc.bind(#{original_reflection_type}).params(arg: #{original_reflection_type}).void"),
                ],
                return_type: original_reflection_type,
              )
            end
          end
        end
      end

      # activerecord-7.1.1/lib/active_record/persistence.rb
      sig { params(rbi_scope: ::RBI::Scope).void }
      def populate_persistent_class_methods(rbi_scope)
        model_name = rbi_scope.fully_qualified_name

        rbi_scope.create_method('create', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method('create!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method('build', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: T_UNTYPED)], return_type: model_name, class_method: true)
        rbi_scope.create_method(
          'insert',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_opt_param('record_timestamps', type: as_nilable_type('::Time'), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method(
          'insert_all',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_opt_param('record_timestamps', type: as_nilable_type('::Time'), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method(
          'insert!',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_opt_param('record_timestamps', type: as_nilable_type('::Time'), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method(
          'insert_all!',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_opt_param('record_timestamps', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method(
          'upsert',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_kw_opt_param('on_duplicate', type: T_UNTYPED, default: ':update'),
            create_kw_opt_param('update_only', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('record_timestamps', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method(
          'upsert_all',
          parameters: [
            create_param('attributes', type: T_UNTYPED),
            create_kw_opt_param('on_duplicate', type: T_UNTYPED, default: ':update'),
            create_kw_opt_param('update_only', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('returning', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('unique_by', type: T_UNTYPED, default: 'nil'),
            create_kw_opt_param('record_timestamps', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
          ],
          return_type: '::ActiveRecord::Result',
          class_method: true,
        )
        rbi_scope.create_method('instantiate', parameters: [create_param('attributes', type: T_UNTYPED), create_opt_param('column_types', type: T_UNTYPED, default: '{}'), create_block_param('block', type: T_UNTYPED)], return_type: model_name, class_method: true)
        # @TODO updateの真の引数は `as_any(TODO_PRIMARY_KEY, as_array(TODO_PRIMARY_KEY))` で返り値も `as_any(model_name, as_array(model_name))` だが・・・
        rbi_scope.create_method('update', parameters: [create_opt_param('id', type: TODO_PRIMARY_KEY, default: ':all'), create_param('attributes', type: T_UNTYPED)], return_type: as_array(model_name), class_method: true)
        rbi_scope.create_method('update!', parameters: [create_opt_param('id', type: TODO_PRIMARY_KEY, default: ':all'), create_param('attributes', type: T_UNTYPED)], return_type: as_array(model_name), class_method: true)
        rbi_scope.create_method('query_constraints', parameters: [create_rest_param('columns_list', type: '::Symbol')], class_method: true)
        # @TODO destroyの真の引数は `as_any(TODO_PRIMARY_KEY, as_array(TODO_PRIMARY_KEY))` で返り値も `as_any(model_name, as_array(model_name))` だが・・・
        rbi_scope.create_method('destroy', parameters: [create_param('id', type: TODO_PRIMARY_KEY)], return_type: model_name, class_method: true)
        rbi_scope.create_method('delete', parameters: [create_param('id_or_array', type: as_any(TODO_PRIMARY_KEY, as_array(TODO_PRIMARY_KEY)))], return_type: '::Integer', class_method: true)
      end

      # Post::GeneratedRelationMethods
      # activerecord-7.1.1/lib/active_record/relation/delegation.rb
      sig { params(rbi_scope: ::RBI::Scope, activerecord_model: ConstantType).returns(::RBI::Scope) }
      def create_generated_relation_methods_module(rbi_scope, activerecord_model)
        model_name = rbi_scope.fully_qualified_name
        generated_relation_methods_module = rbi_scope.create_module(GENERATED_RELATION_METHODS_NAME)

        populate_finder_methods(generated_relation_methods_module, model_name)
        populate_calculations(generated_relation_methods_module)
        populate_spawn(generated_relation_methods_module)
        populate_query_methods(generated_relation_methods_module)

        generated_relation_methods_module
      end

      # class Post::ActiveRecord_Relation < ::ActiveRecord::Relation
      sig { params(rbi_scope: ::RBI::Scope, activerecord_model: ConstantType).void }
      def create_active_record_relation(rbi_scope, activerecord_model)
        model_name = "::#{activerecord_model.name}"
        ar_relation = rbi_scope.create_class(ACTIVERECORD_RELATION_NAME, superclass_name: '::ActiveRecord::Relation')

        ar_relation.create_include(GENERATED_RELATION_METHODS_NAME)

        common_block_param = as_nilable_type("T.proc.params(arg: #{model_name}).void")

        # Overwrite ::ActiveRecord::Relation's instant methods.
        # We DONOT Trust and Depend on Tapioca
        ar_relation.create_method('any?', return_type: T_BOOLEAN)
        ar_relation.create_method('blank?', return_type: T_BOOLEAN)
        ar_relation.create_method('build', parameters: [create_opt_param('arg', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('cache_key', parameters: [create_opt_param('timestamp_column', type: T_UNTYPED, default: "'updated_at'")], return_type: '::String')
        ar_relation.create_method('cache_key_with_version', return_type: '::String')
        ar_relation.create_method('cache_version', parameters: [create_opt_param('timestamp_column', type: T_UNTYPED, default: ':updated_at')], return_type: '::String')
        # 本当はattributesに配列を与えた場合はT::Array[]を返す,しかしsorbetで対応できないしそんな使い方はしてほしくない
        ar_relation.create_method('create', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('create!', parameters: [create_opt_param('attributes', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('create_or_find_by', parameters: [create_param('attributes', type: T_UNTYPED), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('create_or_find_by!', parameters: [create_param('attributes', type: T_UNTYPED), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('eager_loading?', return_type: T_BOOLEAN)
        ar_relation.create_method('empty?', return_type: T_BOOLEAN)
        ar_relation.create_method('empty_scope?', return_type: T_BOOLEAN)
        ar_relation.create_method('explain', parameters: [create_rest_param('options', type: T_UNTYPED)], return_type: '::String')
        ar_relation.create_method(
          'find_each',
          parameters: [
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('batch_size', type: 'Integer', default: '1000'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: "T::Enumerator[#{model_name}]",
        )
        ar_relation.create_method(
          'find_in_batches',
          parameters: [
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('batch_size', type: 'Integer', default: '1000'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: "T::Enumerator[#{model_name}]",
        )
        ar_relation.create_method('find_or_create_by', parameters: [create_param('attributes', type: T_UNTYPED), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('find_or_create_by!', parameters: [create_param('attributes', type: T_UNTYPED), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('find_or_initialize_by', parameters: [create_param('attributes', type: T_UNTYPED), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('has_limit_or_offset?', return_type: T_BOOLEAN)
        ar_relation.create_method(
          'in_batches',
          parameters: [
            create_kw_opt_param('of', type: 'Integer', default: '1000'),
            create_kw_opt_param('start', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('finish', type: T_UNTYPED, default: 'nil'), # @TODO primary keyの型
            create_kw_opt_param('load', type: T_BOOLEAN, default: 'false'),
            create_kw_opt_param('error_on_ignore', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_kw_opt_param('order', type: T_UNTYPED, default: ':asc'),
            create_kw_opt_param('use_ranges', type: as_nilable_type(T_BOOLEAN), default: 'nil'),
            create_block_param('block', type: as_nilable_type("T.proc.params(arg: #{model_name}).void")),
          ],
          return_type: '::ActiveRecord::Batches::BatchEnumerator', # @TODO ActiveRecord::Batches::BatchEnumerator
        )
        ar_relation.create_method('inspect', return_type: '::String')
        ar_relation.create_method('joined_includes_values', return_type: as_array(T_UNTYPED))
        ar_relation.create_method('klass', return_type: "T::Class[#{model_name}]")
        ar_relation.create_method('load', return_type: T_SELF)
        ar_relation.create_method('load_async', return_type: T_SELF)
        ar_relation.create_method('loaded', return_type: T_BOOLEAN)
        ar_relation.create_method('loaded?', return_type: T_BOOLEAN)
        ar_relation.create_method('locked?', return_type: T_BOOLEAN)
        ar_relation.create_method('many?', return_type: T_BOOLEAN)
        ar_relation.create_method('model', return_type: "T::Class[#{model_name}]")
        ar_relation.create_method('new', parameters: [create_opt_param('arg', type: T_UNTYPED, default: 'nil'), create_block_param('block', type: common_block_param)], return_type: model_name)
        ar_relation.create_method('none?', return_type: T_BOOLEAN)
        ar_relation.create_method('one?', return_type: T_BOOLEAN)
        ar_relation.create_method('preload_associations', parameters: [create_param('relation', type: T_UNTYPED)], return_type: T_SELF)
        ar_relation.create_method('records', return_type: as_array(model_name))
        ar_relation.create_method('reload', return_type: T_SELF)
        ar_relation.create_method('reset', return_type: T_SELF)
        ar_relation.create_method('scheduled?', return_type: T_BOOLEAN)
        ar_relation.create_method('scope_for_create', return_type: 'T::Hash[T.untyped, T.untyped]')
        ar_relation.create_method('size', return_type: '::Integer')
        ar_relation.create_method('table', return_type: '::Arel::Table')
        ar_relation.create_method('to_a', return_type: as_array(model_name))
        ar_relation.create_method('to_ary', return_type: as_array(model_name))
        ar_relation.create_method('to_sql', return_type: '::String')
        # `ActiveRecord::Relation#update` has 2 overload signatures.
        #
        # ApplicationRecord.where(...).update(1, name: '🍕')
        # ApplicationRecord.where(...).update(name: '🍕')
        #
        # So Tapioca generates a rbi file below.
        #
        # ```
        # def update(id = T.unsafe(nil), attributes); end
        # def update!(id = T.unsafe(nil), attributes); end
        # ```
        #
        # However this causes a type error.
        #
        # # OK
        # ApplicationRecord.where(...).update(1, name: '🍕')
        # # NG
        # ApplicationRecord.where(...).update(name: '🍕')
        # > Not enough arguments provided for method `ActiveRecord::Relation#update`. Expected: `1..2`, got: `1` (7004)
        #
        # To avoid the error, we must redeclare parameters as rest parameters.
        ar_relation.create_method('update', parameters: [create_rest_param('attributes', type: T_UNTYPED)], return_type: T_UNTYPED)
        ar_relation.create_method('update!', parameters: [create_rest_param('attributes', type: T_UNTYPED)], return_type: T_UNTYPED)
        ar_relation.create_method('values', return_type: 'T::Hash[T.untyped, T.untyped]')
        ar_relation.create_method('values_for_queries', return_type: 'T::Hash[T.untyped, T.untyped]')
        ar_relation.create_method('where_values_hash', parameters: [create_opt_param('relation_table_name', type: T_UNTYPED, default: 'klass.table_name')], return_type: 'T::Hash[T.untyped, T.untyped]')
      end

      # @TODO
      # class Post::ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
      sig { params(rbi_scope: ::RBI::Scope).void }
      def create_active_record_associations_collection_proxy(rbi_scope)
        collection_proxy = rbi_scope.create_class('ActiveRecord_Associations_CollectionProxy', superclass_name: '::ActiveRecord::Associations::CollectionProxy')
        collection_proxy.create_include(GENERATED_RELATION_METHODS_NAME)
      end

      # @TODO
      # class Post::ActiveRecord_AssociationRelation < ::ActiveRecord::AssociationRelation
      sig { params(rbi_scope: ::RBI::Scope).void }
      def create_active_record_association_relation(rbi_scope)
        association_relation = rbi_scope.create_class('ActiveRecord_AssociationRelation', superclass_name: '::ActiveRecord::AssociationRelation')
        association_relation.create_include(GENERATED_RELATION_METHODS_NAME)
      end

      # @TODO
      # class Post::ActiveRecord_DisableJoinsAssociationRelation < ::ActiveRecord::DisableJoinsAssociationRelation
      sig { params(rbi_scope: ::RBI::Scope).void }
      def create_active_record_disable_joins_association_relation(rbi_scope)
        disable_joins_association_relation = rbi_scope.create_class('ActiveRecord_DisableJoinsAssociationRelation', superclass_name: '::ActiveRecord::DisableJoinsAssociationRelation')
        disable_joins_association_relation.create_include(GENERATED_RELATION_METHODS_NAME)
      end

      private
      ######################################################################################################################################################

      # [finder](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html)
      sig { params(generated_relation_methods_module: ::RBI::Scope, model_name: ::String).void }
      def populate_finder_methods(generated_relation_methods_module, model_name)
        # activerecord-7.1.1/lib/active_record/relation/finder_methods.rb
        generated_relation_methods_module.create_method('find', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: model_name)
        generated_relation_methods_module.create_method('find_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('find_by!', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name)
        generated_relation_methods_module.create_method('take', parameters: [create_opt_param('limit', type: as_nilable_type('::Integer'), default: 'nil')], return_type: as_array(model_name))
        generated_relation_methods_module.create_method('take!', return_type: model_name)
        generated_relation_methods_module.create_method('sole', return_type: model_name)
        generated_relation_methods_module.create_method('find_sole_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name)
        generated_relation_methods_module.create_method('first', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('first!', return_type: model_name)
        generated_relation_methods_module.create_method('last', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('last!', return_type: model_name)
        generated_relation_methods_module.create_method('second', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('second!', return_type: model_name)
        generated_relation_methods_module.create_method('third', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('third!', return_type: model_name)
        generated_relation_methods_module.create_method('fourth', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('fourth!', return_type: model_name)
        generated_relation_methods_module.create_method('fifth', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('fifth!', return_type: model_name)
        generated_relation_methods_module.create_method('forty_two', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('forty_two!', return_type: model_name)
        generated_relation_methods_module.create_method('third_to_last', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('third_to_last!', return_type: model_name)
        generated_relation_methods_module.create_method('second_to_last', return_type: as_nilable_type(model_name))
        generated_relation_methods_module.create_method('second_to_last!', return_type: model_name)
        generated_relation_methods_module.create_method('exists?', parameters: [create_opt_param('args', type: T_UNTYPED, default: ':none')], return_type: T_BOOLEAN)
        generated_relation_methods_module.create_method('include?', parameters: [create_param('record', type: as_nilable_type(model_name))], return_type: T_BOOLEAN)
        generated_relation_methods_module.create_method('member?', parameters: [create_param('record', type: as_nilable_type(model_name))], return_type: T_BOOLEAN)
      end

      # [calculation](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html)
      sig { params(generated_relation_methods_module: ::RBI::Scope).void }
      def populate_calculations(generated_relation_methods_module)
        # activerecord-7.1.1/lib/active_record/relation/calculations.rb
        generated_relation_methods_module.create_method('count', parameters: [create_opt_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')), default: 'nil')], return_type: '::Integer')
        generated_relation_methods_module.create_method('async_count', parameters: [create_opt_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')), default: 'nil')], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('average', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('async_average', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('minimum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('async_minimum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('maximum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('async_maximum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('async_sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('calculate', parameters: [create_param('operation', type: '::Symbol'), create_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')))], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('pluck', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: as_array(T_UNTYPED))
        generated_relation_methods_module.create_method('async_pluck', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('pick', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: T_UNTYPED)
        generated_relation_methods_module.create_method('async_pick', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: '::ActiveRecord::Promise')
        generated_relation_methods_module.create_method('ids', return_type: as_array(T_UNTYPED))
        generated_relation_methods_module.create_method('async_ids', return_type: '::ActiveRecord::Promise')
      end

      # [spawn](http://api.rubyonrails.org/classes/ActiveRecord/SpawnMethods.html)
      sig { params(generated_relation_methods_module: ::RBI::Scope).void }
      def populate_spawn(generated_relation_methods_module)
        # activerecord-7.1.1/lib/active_record/relation/spawn_methods.rb
        generated_relation_methods_module.create_method('merge', parameters: [create_param('other', type: '::ActiveRecord::Relation'), create_rest_param('rest', type: '::ActiveRecord::Relation')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('except', parameters: [create_rest_param('skips', type: '::Symbol')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('only', parameters: [create_rest_param('onlies', type: '::Symbol')], return_type: ACTIVERECORD_RELATION_NAME)
      end

      # [query](http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html)
      sig { params(generated_relation_methods_module: ::RBI::Scope).void }
      def populate_query_methods(generated_relation_methods_module)
        # activerecord-7.1.1/lib/active_record/relation/query_methods.rb
        common_type = 'T.any(::String, ::Symbol, T::Hash[T.untyped, T.untyped])'

        generated_relation_methods_module.create_method('includes', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('eager_load', parameters: [create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('preload', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('extract_associated', parameters: [create_param('association', type: '::Symbol')], return_type: as_array(T_UNTYPED))
        generated_relation_methods_module.create_method('references', parameters: [create_param('arg', type: common_type), create_rest_param('table_names', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('select', parameters: [create_param('field', type: common_type), create_rest_param('fields', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('with', parameters: [create_param('arg', type: 'T::Hash[T.untyped, T.untyped]'), create_rest_param('args', type: 'T::Hash[T.untyped, T.untyped]')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('reselect', parameters: [create_param('arg', type: common_type), create_rest_param('fields', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('group', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('regroup', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('order', parameters: [create_param('arg', type: 'T.any(::String, ::Symbol, T::Hash[T.untyped, T.any(::String, ::Symbol)])'), create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.untyped, T.untyped])')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('in_order_of', parameters: [create_param('column', type: as_any('::String', '::Symbol')), create_param('values', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('reorder', parameters: [create_param('arg', type: 'T.any(::String, ::Symbol, T::Hash[T.untyped, T.untyped])'), create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.untyped, T.untyped])')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('unscope', parameters: [create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('left_outer_joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('left_joins', parameters: [create_param('arg', type: common_type), create_rest_param('args', type: common_type)], return_type: ACTIVERECORD_RELATION_NAME)
        # If no argument is passed, where returns a new instance of WhereChain, that can be chained with WhereChain#not, WhereChain#missing, or WhereChain#associated.
        generated_relation_methods_module.create_method('where', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('rewhere', parameters: [create_param('conditions', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('invert_where', return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('structurally_compatible?', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: T_BOOLEAN)
        generated_relation_methods_module.create_method('and', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('or', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('having', parameters: [create_param('opts', type: '::String'), create_rest_param('rest', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('limit', parameters: [create_param('value', type: '::Integer')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('offset', parameters: [create_param('value', type: '::Integer')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('lock', parameters: [create_opt_param('locks', type: T_BOOLEAN, default: 'true')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('none', return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('readonly', parameters: [create_opt_param('locks', type: T_BOOLEAN, default: 'true')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('strict_loading', parameters: [create_opt_param('value', type: T_BOOLEAN, default: 'true')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('create_with', parameters: [create_param('other', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('from', parameters: [create_param('value', type: T_UNTYPED), create_opt_param('subquery_name', type: T_UNTYPED, default: 'nil')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('distinct', parameters: [create_opt_param('value', type: T_BOOLEAN, default: 'false')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('extending', parameters: [create_rest_param('modules', type: '::Module'), create_block_param('block', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('optimizer_hints', parameters: [create_rest_param('args', type: '::String')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('reverse_order', return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('annotate', parameters: [create_rest_param('args', type: '::String')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('uniq!', parameters: [create_param('name', type: T_UNTYPED)], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('excluding', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: ACTIVERECORD_RELATION_NAME)
        generated_relation_methods_module.create_method('without', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: ACTIVERECORD_RELATION_NAME)
      end

      sig { params(column_type: T.untyped).returns(String) }
      def type_for_activerecord_value(column_type)
        case column_type
        when ::ActiveRecord::Type::Integer
          "::Integer"
        when ::ActiveRecord::Type::String
          "::String"
        when ::ActiveRecord::Type::Date
          "::Date"
        when ::ActiveRecord::Type::Decimal
          "::BigDecimal"
        when ::ActiveRecord::Type::Float
          "::Float"
        when ::ActiveRecord::Type::Boolean
          "T::Boolean"
        when ::ActiveRecord::Type::DateTime, ::ActiveRecord::Type::Time
          "::Time"
        when ::ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter
          "::ActiveSupport::TimeWithZone"
        when ::ActiveRecord::Enum::EnumType
          "::String"
        else
          "T.untyped"
        end
      end
    end
  end
end
