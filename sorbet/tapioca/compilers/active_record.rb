# typed: true

begin
  require "active_record"
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

      ConstantType = type_member {{ fixed: ::T.class_of(::ActiveRecord::Base) }}

      sig { params(type: ::String).returns(::String) }
      def as_array(type)
        "T::Array[#{type}]"
      end

      sig { params(types: ::String).returns(::String) }
      def as_any(*types)
        "T.any(#{types.join(', ')})"
      end

      sig { override.returns(::T::Enumerable[Module]) }
      def self.gather_constants
        ::ActiveRecord::Base.descendants.reject(&:abstract_class?)
      end

      sig { override.void }
      def decorate
        root.create_path(constant) do |model|
          model_name = constant.name.to_s

          # Post::GeneratedAttributeMethods
          populate_generated_attribute_methods(model, constant)

          # Post::GeneratedAssociationMethods
          populate_generated_association_methods(model, constant)

          # Post::Internal__CustomFinderMethods
          populate_internal_custom_finder_methods(model, constant)

          # [relation](http://api.rubyonrails.org/classes/ActiveRecord/Relation.html),
          # [collection proxy](https://api.rubyonrails.org/classes/ActiveRecord/Associations/CollectionProxy.html),
          # [query](http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html),
          # [spawn](http://api.rubyonrails.org/classes/ActiveRecord/SpawnMethods.html),
          # [finder](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html), and
          # [calculation](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html) methods.


          ##############################################################################################################
          # Post::ActiveRecord_Relation                                                                                #
          # Post::GeneratedRelationMethods                                                                             #
          ##############################################################################################################
          ar_relation = model.create_class('ActiveRecord_Relation', superclass_name: '::ActiveRecord::Relation')
          generated_relation_methods = model.create_class('GeneratedRelationMethods', superclass_name: '::ActiveRecord::Relation')

          ##############################################################################################################
          # Post::ActiveRecord_AssociationRelation                                                                     #
          ##############################################################################################################
          association_relation = model.create_class('ActiveRecord_AssociationRelation', superclass_name: '::ActiveRecord::Relation')

          # [relation](http://api.rubyonrails.org/classes/ActiveRecord/Relation.html)

          # [collection proxy](https://api.rubyonrails.org/classes/ActiveRecord/Associations/CollectionProxy.html)

          # [query](http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html),
          association_relation.create_method('and', parameters: [create_param('other', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('annotate', parameters: [create_rest_param('args', type: '::String')], return_type: T_SELF)
          association_relation.create_method('async!', return_type: T_SELF)
          association_relation.create_method('create_with', parameters: [create_param('other', type: T_UNTYPED)], return_type: model_name)
          association_relation.create_method('distinct', parameters: [create_opt_param('value', type: 'T::Boolean', default: 'false')], return_type: T_SELF)
          association_relation.create_method('eager_load', parameters: [create_rest_param('args', type: '::Symbol')], return_type: T_SELF)
          association_relation.create_method('excluding', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: T_SELF)
          association_relation.create_method('extending', parameters: [create_rest_param('modules', type: '::Module'), create_block_param('block', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('extract_associated', parameters: [create_param('association', type: '::Symbol')], return_type: T_SELF)
          association_relation.create_method('from', parameters: [create_param('value', type: T_UNTYPED), create_opt_param('subquery_name', type: T_UNTYPED, default: 'nil')], return_type: T_SELF)
          association_relation.create_method('group', parameters: [create_rest_param('args', type: 'T.any(::String, ::Symbol)')], return_type: T_SELF)
          association_relation.create_method('having', parameters: [create_param('opts', type: '::String'), create_rest_param('rest', type: '::String')], return_type: T_SELF)
          association_relation.create_method('in_order_of', parameters: [create_param('column', type: 'T.any(::String, ::Symbol)'), create_rest_param('values', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('includes', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('invert_where', return_type: T_SELF)
          association_relation.create_method('joins', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('left_joins', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('left_outer_joins', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('limit', parameters: [create_param('value', type: '::Integer')], return_type: T_SELF)
          association_relation.create_method('lock', parameters: [create_opt_param('locks', type: 'T::Boolean', default: 'true')], return_type: T_SELF)
          association_relation.create_method('none', return_type: T_SELF)
          association_relation.create_method('offset', parameters: [create_param('value', type: '::Integer')], return_type: T_SELF)
          association_relation.create_method('optimizer_hints', parameters: [create_rest_param('args', type: '::String')], return_type: T_SELF)
          association_relation.create_method('or', parameters: [create_param('other', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('order', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('preload', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('readonly', parameters: [create_opt_param('locks', type: 'T::Boolean', default: 'true')], return_type: T_SELF)
          association_relation.create_method('references', parameters: [create_rest_param('table_names', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('regroup', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('reorder', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('reselect', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('reverse_order', return_type: T_SELF)
          association_relation.create_method('rewhere', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('select', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('strict_loading', parameters: [create_opt_param('value', type: 'T::Boolean', default: 'true')], return_type: T_SELF)
          association_relation.create_method('structurally_compatible?', parameters: [create_param('other', type: T_UNTYPED)], return_type: 'T::Boolean')
          association_relation.create_method('uniq!', parameters: [create_param('name', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('unscope', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          # 引数ありの時と無しの時でreturn typeが異なる・・・
          association_relation.create_method('where', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('with', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('without', parameters: [create_rest_param('records', type: T_UNTYPED)], return_type: T_SELF)

          # [spawn](http://api.rubyonrails.org/classes/ActiveRecord/SpawnMethods.html)
          association_relation.create_method('except', parameters: [create_rest_param('args', type: '::Symbol')], return_type: T_SELF)
          association_relation.create_method('merge', parameters: [create_param('other', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('only', parameters: [create_rest_param('args', type: '::Symbol')], return_type: T_SELF)

          # [finder](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html)
          association_relation.create_method('exists?', parameters: [create_opt_param('conditions', type: T_UNTYPED, default: ':none')], return_type: 'T::Boolean')
          association_relation.create_method('fifth', return_type: as_nilable_type(model_name))
          association_relation.create_method('fifth!', return_type: model_name)
          association_relation.create_method('find', parameters: [create_param('arg', type: T_UNTYPED)], return_type: model_name)
          association_relation.create_method('find_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: as_nilable_type(model_name))
          association_relation.create_method('find_by!', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name)
          association_relation.create_method('find_sole_by', parameters: [create_param('arg', type: T_UNTYPED), create_rest_param('args', type: T_UNTYPED)], return_type: model_name)
          association_relation.create_method('first', return_type: as_nilable_type(model_name))
          association_relation.create_method('first!', return_type: model_name)
          association_relation.create_method('forty_two', return_type: as_nilable_type(model_name))
          association_relation.create_method('forty_two!', return_type: model_name)
          association_relation.create_method('fourth', return_type: as_nilable_type(model_name))
          association_relation.create_method('fourth!', return_type: model_name)
          association_relation.create_method('include?', parameters: [create_param('record', type: T_UNTYPED)], return_type: 'T::Boolean')
          association_relation.create_method('last', return_type: as_nilable_type(model_name))
          association_relation.create_method('last!', return_type: model_name)
          association_relation.create_method('member?', parameters: [create_param('record', type: T_UNTYPED)], return_type: 'T::Boolean')
          association_relation.create_method('second', return_type: as_nilable_type(model_name))
          association_relation.create_method('second!', return_type: model_name)
          association_relation.create_method('second_to_last', return_type: as_nilable_type(model_name))
          association_relation.create_method('second_to_last!', return_type: model_name)
          association_relation.create_method('sole', return_type: model_name)
          association_relation.create_method('take', parameters: [create_opt_param('limit', type: '::Integer', default: 'nil')], return_type: "T::Array[#{model_name}]")
          association_relation.create_method('take!', return_type: model_name)
          association_relation.create_method('third', return_type: as_nilable_type(model_name))
          association_relation.create_method('third!', return_type: model_name)
          association_relation.create_method('third_to_last', return_type: as_nilable_type(model_name))
          association_relation.create_method('third_to_last!', return_type: model_name)

          # [calculation](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html)
          association_relation.create_method('async_average', parameters: [create_param('column_name', type: '::String')], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_count', parameters: [create_opt_param('column_name', type: T_UNTYPED, default: 'nil')], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_ids', return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_maximum', parameters: [create_param('column_name', type: T_UNTYPED)], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_minimum', parameters: [create_param('column_name', type: T_UNTYPED)], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_pick', parameters: [create_rest_param('column_names', type: T_UNTYPED)], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_pluck', parameters: [create_rest_param('column_names', type: T_UNTYPED)], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('async_sum', parameters: [create_opt_param('identity_or_column', type: T_UNTYPED, default: 'nil')], return_type: '::ActiveRecord::Promise')
          association_relation.create_method('average', parameters: [create_param('column_name', type: 'T.any(::String, ::Symbol)')], return_type: '::Numeric')
          association_relation.create_method('calculate', parameters: [create_param('operation', type: '::Symbol'), create_param('column_name', type: T_UNTYPED)], return_type: T_SELF)
          association_relation.create_method('count', parameters: [create_opt_param('column_name', type: T_UNTYPED, default: 'nil')], return_type: '::Numeric')
          association_relation.create_method('ids', return_type: 'T::Array[::Integer]')
          association_relation.create_method('maximum', parameters: [create_param('column_name', type: T_UNTYPED)], return_type: '::Numeric')
          association_relation.create_method('minimum', parameters: [create_param('column_name', type: T_UNTYPED)], return_type: '::Numeric')
          association_relation.create_method('pick', parameters: [create_rest_param('column_names', type: T_UNTYPED)], return_type: T_UNTYPED)
          association_relation.create_method('pluck', parameters: [create_rest_param('column_names', type: T_UNTYPED)], return_type: T_UNTYPED)
          association_relation.create_method('sum', parameters: [create_opt_param('initial_value_or_column', type: '::Integer', default: '0')], return_type: T_SELF)


        end
      end

      # Post::ActiveRecord_AssociationRelation
      sig { params(model: ::RBI::Scope, constant: ConstantType).void }
      def populate_active_record_association_relation(model, constant)
      end

      # Post::GeneratedAttributeMethods
      sig { params(model: ::RBI::Scope, constant: ConstantType).void }
      def populate_generated_attribute_methods(model, constant)
        model_name = constant.name.to_s

        generated_attribute_methods = model.create_module("::#{model_name}::GeneratedAttributeMethods")
        model.create_include("::#{model_name}::GeneratedAttributeMethods")

        attribute_aliases_map = constant.attribute_aliases.invert

        # @TODO attribute で宣言された動的カラム
        attributes_to_define_after_schema_loads = constant.attributes_to_define_after_schema_loads

        constant.columns.each do |column|
          column_name = column.name
          nullable = column.null
          comments = column.comment.nil? ? [] : [RBI::Comment.new(column.comment)]

          active_model_type = constant.attribute_types[column_name] # ActiveModel::Type::Value
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
          generated_attribute_methods.create_method("#{column_name}?", return_type: 'T::Boolean')

          # ActiveRecord::AttributeMethods::Dirty activerecord-7.1.1/lib/active_record/attribute_methods/dirty.rb
          # ------------------------------
          # saved_change_to_%s?
          generated_attribute_methods.create_method("saved_change_to_#{column_name}?", return_type: 'T::Boolean')
          # saved_change_to_%s
          generated_attribute_methods.create_method("saved_change_to_#{column_name}", return_type: as_nilable_type("[#{nilable_column_type}, #{column_type}]"))
          # %s_before_last_save
          generated_attribute_methods.create_method("#{column_name}_before_last_save", return_type: nilable_column_type)
          # will_save_change_to_%s?
          generated_attribute_methods.create_method("will_save_change_to_#{column_name}?", return_type: 'T::Boolean')
          # %s_change_to_be_saved
          generated_attribute_methods.create_method("#{column_name}_change_to_be_saved", return_type: as_nilable_type("[#{nilable_column_type}, T.untyped]"))
          # %s_in_database
          generated_attribute_methods.create_method("#{column_name}_in_database", return_type: column_type)

          # ActiveModel::Dirty activemodel-7.1.1/lib/active_model/dirty.rb
          # ------------------------------
          # %s_previously_changed?
          generated_attribute_methods.create_method("#{column_name}_previously_changed?", parameters: [create_kw_opt_param('from', type: nilable_column_type, default: 'nil'), create_kw_opt_param('to', type: nilable_column_type, default: 'nil')], return_type: 'T::Boolean')
          # %s_changed?
          generated_attribute_methods.create_method("#{column_name}changed?", return_type: 'T::Boolean')
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
          generated_attribute_methods.create_method("#{column_name}_came_from_user?", return_type: 'T::Boolean')
        end
      end

      # Post::GeneratedAssociationMethods
      sig { params(model: ::RBI::Scope, constant: ConstantType).void }
      def populate_generated_association_methods(model, constant)
        model_name = constant.name.to_s
        generated_association_methods = model.create_module("::#{model_name}::GeneratedAssociationMethods")
        model.create_include("::#{model_name}::GeneratedAssociationMethods")

        activerecord_associations_collection_proxy_name = "::#{model_name}::ActiveRecord_Associations_CollectionProxy"
        activerecord_associations_collection_proxy = model.create_class(activerecord_associations_collection_proxy_name, superclass_name: '::ActiveRecord::Relation')

        constant.reflections.each do |association_name, reflection|
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

      sig { params(model: ::RBI::Scope, constant: ConstantType).void }
      def populate_internal_custom_finder_methods(model, constant)
        model_name = constant.name.to_s
        generated_association_methods = model.create_module("::#{model_name}::Internal__CustomFinderMethods")
        model.create_include("::#{model_name}::Internal__CustomFinderMethods")


      end

      # [finder](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html)
      sig { params(generated_association_methods: ::RBI::Scope).void }
      def populate_finder_methods(generated_association_methods)
        # activerecord-7.1.1/lib/active_record/relation/finder_methods.rb
        generated_association_methods.create_method('find', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_ATTACHED)
        generated_association_methods.create_method('find_by', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('find_by!', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_ATTACHED)
        generated_association_methods.create_method('take', parameters: [create_opt_param('limit', type: as_nilable_type('::Integer'), default: 'nil')], return_type: as_array(T_ATTACHED))
        generated_association_methods.create_method('take!', return_type: T_ATTACHED)
        generated_association_methods.create_method('sole', return_type: T_ATTACHED)
        generated_association_methods.create_method('find_sole_by', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: T_ATTACHED)
        generated_association_methods.create_method('first', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('first!', return_type: T_ATTACHED)
        generated_association_methods.create_method('last', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('last!', return_type: T_ATTACHED)
        generated_association_methods.create_method('second', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('second!', return_type: T_ATTACHED)
        generated_association_methods.create_method('third', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('third!', return_type: T_ATTACHED)
        generated_association_methods.create_method('fourth', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('fourth!', return_type: T_ATTACHED)
        generated_association_methods.create_method('fifth', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('fifth!', return_type: T_ATTACHED)
        generated_association_methods.create_method('forty_two', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('forty_two!', return_type: T_ATTACHED)
        generated_association_methods.create_method('third_to_last', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('third_to_last!', return_type: T_ATTACHED)
        generated_association_methods.create_method('second_to_last', return_type: as_nilable_type(T_ATTACHED))
        generated_association_methods.create_method('second_to_last!', return_type: T_ATTACHED)
        generated_association_methods.create_method('exists?', parameters: [create_opt_param('args', type: T_UNTYPED, default: ':none')], return_type: T_BOOLEAN)
        generated_association_methods.create_method('include?', parameters: [create_param('record', type: as_nilable_type(T_ATTACHED))], return_type: T_BOOLEAN)
        generated_association_methods.create_method('member?', parameters: [create_param('record', type: as_nilable_type(T_ATTACHED))], return_type: T_BOOLEAN)
      end

      # [calculation](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html)
      sig { params(generated_association_methods: ::RBI::Scope).void }
      def populate_calculations(generated_association_methods)
        # activerecord-7.1.1/lib/active_record/relation/calculations.rb
        generated_association_methods.create_method('count', parameters: [create_opt_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')), default: 'nil')], return_type: '::Integer')
        generated_association_methods.create_method('async_count', parameters: [create_opt_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')), default: 'nil')], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('average', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_association_methods.create_method('async_average', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('minimum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_association_methods.create_method('async_minimum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('maximum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: T_UNTYPED)
        generated_association_methods.create_method('async_maximum', parameters: [create_param('column_name', type: as_any('::String', '::Symbol'))], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: T_UNTYPED)
        generated_association_methods.create_method('async_sum', parameters: [create_opt_param('initial_value_or_column', type: as_any('::String', '::Symbol', '::Integer'), default: '0')], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('calculate', parameters: [create_param('operation', type: '::Symbol'), create_param('column_name', type: as_nilable_type(as_any('::String', '::Symbol')))], return_type: T_UNTYPED)
        generated_association_methods.create_method('pluck', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: as_array(T_UNTYPED))
        generated_association_methods.create_method('async_pluck', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('pick', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: T_UNTYPED)
        generated_association_methods.create_method('async_pick', parameters: [create_rest_param('column_names', type: as_any('::Symbol', '::String'))], return_type: '::ActiveRecord::Promise')
        generated_association_methods.create_method('ids', return_type: as_array(T_UNTYPED))
        generated_association_methods.create_method('async_ids', return_type: '::ActiveRecord::Promise')
      end

      # [spawn](http://api.rubyonrails.org/classes/ActiveRecord/SpawnMethods.html)
      # @param return_type '::Post::ActiveRecord_Relation'
      sig { params(generated_association_methods: ::RBI::Scope, activerecord_relation: ::String).void }
      def populate_spawn(generated_association_methods, activerecord_relation)
        # activerecord-7.1.1/lib/active_record/relation/spawn_methods.rb
        generated_association_methods.create_method('merge', parameters: [create_param('other', type: '::ActiveRecord::Relation'), create_rest_param('rest', type: '::ActiveRecord::Relation')], return_type: activerecord_relation)
        generated_association_methods.create_method('except', parameters: [create_rest_param('skips', type: '::Symbol')], return_type: activerecord_relation)
        generated_association_methods.create_method('only', parameters: [create_rest_param('onlies', type: '::Symbol')], return_type: activerecord_relation)
      end

      # [query](http://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html)
      sig { params(generated_association_methods: ::RBI::Scope, activerecord_relation: ::String).void }
      def populate_query_methods(generated_association_methods, activerecord_relation)
        # activerecord-7.1.1/lib/active_record/relation/query_methods.rb
        common_type = 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.untyped])'

        generated_association_methods.create_method('includes', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('eager_load', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('preload', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('extract_associated', parameters: [create_param('association', type: '::Symbol')], return_type: as_array(T_UNTYPED))
        generated_association_methods.create_method('references', parameters: [create_rest_param('table_names', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('select', parameters: [create_rest_param('fields', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('with', parameters: [create_rest_param('args', type: 'T::Hash[T.untyped, T.untyped]')], return_type: activerecord_relation)
        generated_association_methods.create_method('reselect', parameters: [create_rest_param('fields', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('group', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('order', parameters: [create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])')], return_type: activerecord_relation)
        generated_association_methods.create_method('in_order_of', parameters: [create_param('column', type: as_any('::String', '::Symbol')), create_param('values', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('reorder', parameters: [create_rest_param('args', type: 'T.any(::String, ::Symbol, T::Hash[T.any(::String, ::Symbol), T.any(::String, ::Symbol)])')], return_type: activerecord_relation)
        generated_association_methods.create_method('unscope', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('joins', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('left_outer_joins', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        generated_association_methods.create_method('left_joins', parameters: [create_rest_param('args', type: common_type)], return_type: activerecord_relation)
        # If no argument is passed, where returns a new instance of WhereChain, that can be chained with WhereChain#not, WhereChain#missing, or WhereChain#associated.
        generated_association_methods.create_method('where', parameters: [create_rest_param('args', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('rewhere', parameters: [create_param('conditions', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('invert_where', return_type: activerecord_relation)
        generated_association_methods.create_method('structurally_compatible?', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: 'T::Boolean')
        generated_association_methods.create_method('and', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: activerecord_relation)
        generated_association_methods.create_method('or', parameters: [create_param('other', type: '::ActiveRecord::Relation')], return_type: activerecord_relation)
        generated_association_methods.create_method('having', parameters: [create_param('opts', type: '::String'), create_rest_param('rest', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('limit', parameters: [create_param('value', type: '::Integer')], return_type: activerecord_relation)
        generated_association_methods.create_method('offset', parameters: [create_param('value', type: '::Integer')], return_type: activerecord_relation)
        generated_association_methods.create_method('lock', parameters: [create_opt_param('locks', type: 'T::Boolean', default: 'true')], return_type: activerecord_relation)
        generated_association_methods.create_method('none', return_type: activerecord_relation)
        generated_association_methods.create_method('readonly', parameters: [create_opt_param('locks', type: 'T::Boolean', default: 'true')], return_type: activerecord_relation)
        generated_association_methods.create_method('strict_loading', parameters: [create_opt_param('value', type: 'T::Boolean', default: 'true')], return_type: activerecord_relation)
        generated_association_methods.create_method('create_with', parameters: [create_param('other', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('from', parameters: [create_param('value', type: T_UNTYPED), create_opt_param('subquery_name', type: T_UNTYPED, default: 'nil')], return_type: activerecord_relation)
        generated_association_methods.create_method('distinct', parameters: [create_opt_param('value', type: 'T::Boolean', default: 'false')], return_type: activerecord_relation)
        generated_association_methods.create_method('extending', parameters: [create_rest_param('modules', type: '::Module'), create_block_param('block', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('optimizer_hints', parameters: [create_rest_param('args', type: '::String')], return_type: activerecord_relation)
        generated_association_methods.create_method('reverse_order', return_type: activerecord_relation)
        generated_association_methods.create_method('annotate', parameters: [create_rest_param('args', type: '::String')], return_type: activerecord_relation)
        generated_association_methods.create_method('uniq!', parameters: [create_param('name', type: T_UNTYPED)], return_type: activerecord_relation)
        generated_association_methods.create_method('excluding', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: activerecord_relation)
        generated_association_methods.create_method('without', parameters: [create_rest_param('records', type: 'T::Enumerable[::ActiveRecord::Base]')], return_type: activerecord_relation)
      end

      def populate_batches
        # ::ActiveRecord::Relation include ::ActiveRecord::Batches

        # def find_each(start: nil, finish: nil, batch_size: 1000, error_on_ignore: nil, order: DEFAULT_ORDER, &block)
        # def find_in_batches(start: nil, finish: nil, batch_size: 1000, error_on_ignore: nil, order: DEFAULT_ORDER)
        # def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, order: DEFAULT_ORDER, use_ranges: nil, &block)
      end

      def populate_explain
        # ::ActiveRecord::Relation include ::ActiveRecord::Explain

        # NOP
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
