sorbet-railsに関するメモ


- [sorbet-rails.rb](#sorbet-railsrb)
- [sorbet-rails/model\_rbi\_formatter.rb](#sorbet-railsmodel_rbi_formatterrb)
- [sorbet-rails/model\_utils.rb](#sorbet-railsmodel_utilsrb)
- [sorbet-rails/model\_plugins/plugins.rb](#sorbet-railsmodel_pluginspluginsrb)
  - [sorbet-rails/model\_plugins/active\_record\_enum.rb](#sorbet-railsmodel_pluginsactive_record_enumrb)
  - [sorbet-rails/model\_plugins/active\_record\_querying.rb](#sorbet-railsmodel_pluginsactive_record_queryingrb)
  - [sorbet-rails/model\_plugins/active\_relation\_where\_not.rb](#sorbet-railsmodel_pluginsactive_relation_where_notrb)
  - [sorbet-rails/model\_plugins/active\_record\_named\_scope.rb](#sorbet-railsmodel_pluginsactive_record_named_scoperb)
  - [sorbet-rails/model\_plugins/active\_record\_attribute.rb](#sorbet-railsmodel_pluginsactive_record_attributerb)
  - [sorbet-rails/model\_plugins/active\_record\_assoc.rb](#sorbet-railsmodel_pluginsactive_record_assocrb)
  - [sorbet-rails/model\_plugins/active\_record\_serialized\_attribute.rb](#sorbet-railsmodel_pluginsactive_record_serialized_attributerb)
  - [sorbet-rails/model\_plugins/custom\_finder\_methods.rb](#sorbet-railsmodel_pluginscustom_finder_methodsrb)
  - [sorbet-rails/model\_plugins/enumerable\_collections.rb](#sorbet-railsmodel_pluginsenumerable_collectionsrb)
  - [sorbet-rails/model\_plugins/active\_storage\_methods.rb](#sorbet-railsmodel_pluginsactive_storage_methodsrb)



# sorbet-rails.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails.rb

```ruby
# typed: strict
module SorbetRails
  if defined?(Rails)
    require 'sorbet-rails/railtie'
    require 'sorbet-rails/model_rbi_formatter'
    require 'sorbet-rails/type_assert/type_assert'
    require 'sorbet-rails/typed_params'
  end
end
```

# sorbet-rails/model_rbi_formatter.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_rbi_formatter.rb#L72C1-L115C6

```ruby
# typed: strict
require('parlour')
require('sorbet-rails/model_utils')
require('sorbet-rails/model_plugins/plugins')
..................
class SorbetRails::ModelRbiFormatter
..................
  sig { params(root: Parlour::RbiGenerator::Namespace).void }
  def generate_base_rbi(root)
    # This is the backbone of the model_rbi_formatter.
    # It could live in a base plugin but I consider it not replacable and better to leave here
    model_relation_rbi = root.create_class(
      self.model_relation_class_name,
      superclass: "ActiveRecord::Relation",
    )
    model_relation_rbi.create_include(self.model_query_methods_returning_relation_module_name)
    model_relation_rbi.create_constant(
      "Elem",
      value: "type_member {{fixed: #{model_class_name}}}",
    )

    model_assoc_relation_rbi = root.create_class(
      self.model_assoc_relation_class_name,
      superclass: "ActiveRecord::AssociationRelation",
    )
    model_assoc_relation_rbi.create_include(self.model_query_methods_returning_assoc_relation_module_name)
    model_assoc_relation_rbi.create_constant(
      "Elem",
      value: "type_member {{fixed: #{model_class_name}}}",
    )

    collection_proxy_rbi = root.create_class(
      self.model_assoc_proxy_class_name,
      superclass: "ActiveRecord::Associations::CollectionProxy",
    )
    collection_proxy_rbi.create_include(self.model_query_methods_returning_assoc_relation_module_name)
    collection_proxy_rbi.create_constant(
      "Elem",
      value: "type_member {{fixed: #{self.model_class_name}}}",
    )

    model_rbi = root.create_class(
      self.model_class_name,
      superclass: T.must(@model_class.superclass).name,
    )
    model_rbi.create_extend(self.model_query_methods_returning_relation_module_name)
    model_rbi.create_type_alias(
      self.model_relation_type_class_name,
      type: self.model_relation_type_alias
    )
  end
```

# sorbet-rails/model_utils.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_utils.rb

```ruby
# typed: strict
require('sorbet-rails/model_column_utils')
module SorbetRails::ModelUtils


  def add_relation_query_method(
    root,
    method_name,
    parameters: nil,
    builtin_query_method: false,
    custom_return_value: nil
  )
    # a relation querying method will be available on
    # - model (as a class method)
    # - activerecord relation
    # - asocciation collection proxy
    # - association relation
    # in case (1) and (2), it returns a Model::ActiveRecord_Relation
    # in case (3) and (4), it returns a Model::ActiveRecord_AssociationRelation

    # 'unscoped' is a special case where it always returns a ActiveRecord_Relation
    assoc_return_value = method_name == 'unscoped' ? self.model_relation_class_name : self.model_assoc_relation_class_name

    # We can put methods onto modules which are extended/included by the model
    # and relation classes which reduces the RBI footprint for an individual
    # model. However, in Rails 5 query methods that come from scopes or enums
    # get overridden in hidden-definitions so we need to explicitly define them
    # on the model and relation classes.
    if builtin_query_method
      relation_module_rbi = root.create_module(self.model_query_methods_returning_relation_module_name)
      relation_module_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || self.model_relation_class_name,
      )

      assoc_relation_module_rbi = root.create_module(self.model_query_methods_returning_assoc_relation_module_name)
      assoc_relation_module_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || assoc_return_value,
      )
    else
      # force generating these methods because sorbet's hidden-definitions generate & override them
      model_class_rbi = root.create_class(self.model_class_name)
      model_class_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || self.model_relation_class_name,
        class_method: true,
      )

      model_relation_rbi = root.create_class(self.model_relation_class_name)
      model_relation_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || self.model_relation_class_name,
      )

      model_assoc_relation_rbi = root.create_class(self.model_assoc_relation_class_name)
      model_assoc_relation_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || assoc_return_value,
      )

      collection_proxy_rbi = root.create_class(self.model_assoc_proxy_class_name)
      collection_proxy_rbi.create_method(
        method_name,
        parameters: parameters,
        return_type: custom_return_value || assoc_return_value,
      )
    end
  end


```

# sorbet-rails/model_plugins/plugins.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/plugins.rb

```ruby
# typed: strict
require('sorbet-rails/model_plugins/base')
require('sorbet-rails/model_plugins/active_record_enum')
require('sorbet-rails/model_plugins/active_record_querying')
require('sorbet-rails/model_plugins/active_relation_where_not')
require('sorbet-rails/model_plugins/active_record_named_scope')
require('sorbet-rails/model_plugins/active_record_attribute')
require('sorbet-rails/model_plugins/active_record_assoc')
require('sorbet-rails/model_plugins/active_record_serialized_attribute')
require('sorbet-rails/model_plugins/custom_finder_methods')
require('sorbet-rails/model_plugins/enumerable_collections')
require('sorbet-rails/model_plugins/active_storage_methods')

module SorbetRails::ModelPlugins
  extend T::Sig
  include Kernel



end
```

## sorbet-rails/model_plugins/active_record_enum.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_record_enum.rb
https://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html

```ruby
# typed: strict
require ('sorbet-rails/model_plugins/base')
require("sorbet-rails/utils")
class SorbetRails::ModelPlugins::ActiveRecordEnum < SorbetRails::ModelPlugins::Base

  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    return unless model_class.defined_enums.size > 0

    enum_module_name = model_module_name("EnumInstanceMethods")
    enum_module_rbi = root.create_module(enum_module_name)

    model_class_rbi = root.create_class(self.model_class_name)
    model_class_rbi.create_include(enum_module_name)
```

## sorbet-rails/model_plugins/active_record_querying.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_record_querying.rb


```ruby
# typed: strict
require ('sorbet-rails/model_plugins/base')
class SorbetRails::ModelPlugins::ActiveRecordQuerying < SorbetRails::ModelPlugins::Base


  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    # All is a named scope that most method from ActiveRecord::Querying delegate to
    # rails/activerecord/lib/active_record/querying.rb:21
    add_relation_query_method(
      root,
      "all",
      builtin_query_method: true,
    )
    add_relation_query_method(
      root,
      "unscoped",
      parameters: [
        Parameter.new("&block", type: "T.nilable(T.proc.void)"),
      ],
      builtin_query_method: true,
    )

    # It's not possible to typedef all methods in ActiveRecord::Querying module to have the
    # matching type. By generating model-specific sig, we can typedef these methods to return
    # <Model>::Relation class.
    # rails/activerecord/lib/active_record/querying.rb
    model_query_relation_methods = [
      # :select,
      :reselect, :order, :reorder, :group, :limit, :offset, :joins, :left_joins, :left_outer_joins,
      :where, :rewhere, :preload, :extract_associated, :eager_load, :includes, :from, :lock, :readonly, :or,
      :having, :create_with, :distinct, :references, :none, :unscope, :optimizer_hints, :merge, :except, :only,
    ]

    model_query_relation_methods.each do |method_name|
      add_relation_query_method(
        root,
        method_name.to_s,
        parameters: [
          Parameter.new("*args", type: "T.untyped"),
        ],
        builtin_query_method: true,
      ) if exists_class_method?(method_name)
    end
    if exists_class_method?("select")
      # `select` can be used with a block to return an array, or with a list of column name
      # to return a relation object that can be chained.
      # I've seen usage of `select` with a block more often than with a list of column name.
      # here we define select as taking a block, and add a `select_column` method for the other usage
      add_relation_query_method(
        root,
        "select",
        parameters: [
          Parameter.new("&block", type: "T.proc.params(e: #{self.model_class_name}).returns(T::Boolean)"),
        ],
        builtin_query_method: true,
        custom_return_value: "T::Array[#{self.model_class_name}]",
      )
      add_relation_query_method(
        root,
        "select_columns", # select_column is injected by sorbet-rails
        parameters: [
          Parameter.new("*args", type: "T.any(String, Symbol, T::Array[T.any(String, Symbol)])"),
        ],
        builtin_query_method: true,
      )
    end

    # https://api.rubyonrails.org/v6.1.4/classes/ActiveRecord/QueryMethods/WhereChain.html#method-i-missing
    # where.missing is only available in Rails 6.1 and above
    if Rails.version >= "6.1"
      add_relation_query_method(
        root,
        "where_missing", # where_missing is injected by sorbet-rails
        parameters: [
          Parameter.new("*args", type: "Symbol"),
        ],
        builtin_query_method: true,
      )
    end

    # https://api.rubyonrails.org/v7.0.0/classes/ActiveRecord/QueryMethods.html#method-i-in_order_of
    if Rails.version >= "7.0"
      add_relation_query_method(
        root,
        "in_order_of",
        parameters: [
          Parameter.new("column", type: "Symbol"),
          Parameter.new("values", type: "T::Array[T.untyped]")
        ],
        builtin_query_method: true,
      )
    end

    add_relation_query_method(
      root,
      "extending",
      parameters: [
        Parameter.new("*args", type: "T.untyped"),
        Parameter.new("&block", type: "T.nilable(T.proc.void)"),
      ],
      builtin_query_method: true,
    )

    # These are technically "query methods" but they aren't chainable so instead of
    # adding conditionals to `add_relation_query_method` to handle this we'll just
    # handle them here.
    relation_module_rbi = root.create_module(self.model_query_methods_returning_relation_module_name)
    create_in_batches_method(relation_module_rbi, inner_type: self.model_relation_class_name)

    assoc_relation_module_rbi = root.create_module(self.model_query_methods_returning_assoc_relation_module_name)
    create_in_batches_method(assoc_relation_module_rbi, inner_type: self.model_assoc_relation_class_name)
  end
```

## sorbet-rails/model_plugins/active_relation_where_not.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_relation_where_not.rb

```ruby
# typed: strict
require ('sorbet-rails/model_plugins/base')
class SorbetRails::ModelPlugins::ActiveRelationWhereNot < SorbetRails::ModelPlugins::Base

  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    where_not_module_name = self.model_module_name("ActiveRelation_WhereNot")
    where_not_module_rbi = root.create_module(where_not_module_name)

    model_relation_class_rbi = root.create_class(self.model_relation_class_name)
    model_relation_class_rbi.create_include(where_not_module_name)

    model_assoc_relation_rbi = root.create_class(self.model_assoc_relation_class_name)
    model_assoc_relation_rbi.create_include(where_not_module_name)

    # TODO: where.not is a special case that we replace it with a `where_not` method
    # `where` when not given parameters will return a `ActiveRecord::QueryMethods::WhereChain`
    # instance that has a method `not` on it
    where_not_module_rbi.create_method(
      "not",
      parameters: [
        Parameter.new("opts", type: "T.untyped", default: nil),
        Parameter.new("*rest", type: "T.untyped", default: nil),
      ],
      return_type: "T.self_type",
    )
  end
```

## sorbet-rails/model_plugins/active_record_named_scope.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_record_named_scope.rb

```ruby
  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    model_class_rbi = root.create_class(self.model_class_name)

    # Named scope methods are dynamically defined by the `scope` method so their
    # source_location is `lib/active_record/scoping/named.rb`. So we find scopes
    # by two criteria:
    # - they are defined in 'activerecord/lib/active_record/scoping/named.rb'
    # - they are not one of the methods actually defined in that file's source.
    # See: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/scoping/named.rb
    non_dynamic_methods = (
      ActiveRecord::Scoping::Named::ClassMethods.instance_methods +
      ActiveRecord::Scoping::Named::ClassMethods.protected_instance_methods +
      ActiveRecord::Scoping::Named::ClassMethods.private_instance_methods
    )

    (@model_class.methods - non_dynamic_methods).sort.each do |method_name|
      next unless SorbetRails::Utils.valid_method_name?(method_name.to_s)

      method_obj = @model_class.method(method_name)
      next unless method_obj.present? && method_obj.source_location.present?

      source_file = method_obj.source_location[0]
      next unless source_file.include?("lib/active_record/scoping/named.rb")

      add_relation_query_method(
        root,
        method_name.to_s,
        parameters: [
          Parameter.new("*args", type: "T.untyped"),
        ],
      )
    end
  end
```


## sorbet-rails/model_plugins/active_record_attribute.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_record_attribute.rb


```ruby
  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    columns_hash = @model_class.table_exists? ? @model_class.columns_hash : {}
    return unless columns_hash.size > 0

    attribute_module_name = self.model_module_name("GeneratedAttributeMethods")
    attribute_module_rbi = root.create_module(attribute_module_name)

    model_class_rbi = root.create_class(self.model_class_name)
    model_class_rbi.create_include(attribute_module_name)
    model_defined_enums = @model_class.defined_enums

    columns_hash.sort.each do |column_name, column_def|
      if model_defined_enums.has_key?(column_name)
        generate_enum_methods(
          root,
          model_class_rbi,
          attribute_module_rbi,
          model_defined_enums,
          column_name,
          column_def,
        )
      elsif serialization_coder_for_column(column_name)
        next # handled by the ActiveRecordSerializedAttribute plugin
      else
        column_type = type_for_column_def(column_def)
        attribute_module_rbi.create_method(
          column_name.to_s,
          return_type: column_type.to_s,
        )
        attribute_module_rbi.create_method(
          "#{column_name}=",
          parameters: [
            Parameter.new("value", type: value_type_for_attr_writer(column_type))
          ],
          return_type: nil,
        )
      end

      attribute_module_rbi.create_method(
        "#{column_name}?",
        return_type: "T::Boolean",
      )
    end
  end
```


## sorbet-rails/model_plugins/active_record_assoc.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/active_record_assoc.rb

```ruby
.....................................................

  sig do
    params(
      assoc_module_rbi: T.untyped,
      assoc_name: T.untyped,
      reflection: T.untyped
    ).void
  end
  def populate_single_assoc_getter_setter(assoc_module_rbi, assoc_name, reflection)
    # TODO allow people to specify the possible values of polymorphic associations
    assoc_class = assoc_should_be_untyped?(reflection) ? "T.untyped" : "::#{reflection.klass.name}"
    assoc_type = (belongs_to_and_required?(reflection) || has_one_and_required?(reflection) || assoc_class == "T.untyped") ? assoc_class : "T.nilable(#{assoc_class})"

    params = [
      Parameter.new("*args", type: "T.untyped"),
      Parameter.new("&block", type: "T.nilable(T.proc.params(object: #{assoc_class}).void)")
    ]

    assoc_module_rbi.create_method(
      assoc_name.to_s,
      return_type: assoc_type,
    )
    assoc_module_rbi.create_method(
      "build_#{assoc_name}",
      parameters: params,
      return_type: assoc_class,
    )
    assoc_module_rbi.create_method(
      "create_#{assoc_name}",
      parameters: params,
      return_type: assoc_class,
    )
    assoc_module_rbi.create_method(
      "create_#{assoc_name}!",
      parameters: params,
      return_type: assoc_class,
    )
    assoc_module_rbi.create_method(
      "#{assoc_name}=",
      parameters: [
        Parameter.new("value", type: assoc_type)
      ],
      return_type: nil,
    )
    assoc_module_rbi.create_method(
      "reload_#{assoc_name}",
      return_type: assoc_type,
    )
  end
.....................................................
  sig do
    params(
      assoc_module_rbi: T.untyped,
      assoc_name: T.untyped,
      reflection: T.untyped
    ).void
  end
  def populate_collection_assoc_getter_setter(assoc_module_rbi, assoc_name, reflection)
    # TODO allow people to specify the possible values of polymorphic associations
    assoc_class = assoc_should_be_untyped?(reflection) ? "T.untyped" : "::#{reflection.klass.name}"
    relation_class = relation_should_be_untyped?(reflection) ?
      "ActiveRecord::Associations::CollectionProxy" :
      "#{assoc_class}::ActiveRecord_Associations_CollectionProxy"

    assoc_module_rbi.create_method(
      assoc_name.to_s,
      return_type: relation_class,
    )
    unless assoc_should_be_untyped?(reflection)
      id_type = "T.untyped"

      if reflection.klass.table_exists?
        # For DB views, the PK column would not exist.
        id_column = reflection.klass.primary_key

        if id_column
          id_column_def = reflection.klass.columns_hash[id_column]

          # Normally the id_type is an Integer, but it could be a String if using
          # UUIDs.
          id_type = type_for_column_def(id_column_def).to_s if id_column_def
        end
      end

      assoc_module_rbi.create_method(
        "#{assoc_name.singularize}_ids",
        return_type: "T::Array[#{id_type}]",
      )
    end
    assoc_module_rbi.create_method(
      "#{assoc_name}=",
      parameters: [
        Parameter.new("value", type: "T::Enumerable[#{assoc_class}]")
      ],
      return_type: nil,
    )
  end
```


## sorbet-rails/model_plugins/active_record_serialized_attribute.rb

使ってほしくない

```ruby
```


## sorbet-rails/model_plugins/custom_finder_methods.rb

使ってほしくない

sorbet-rails/lib/sorbet-rails/rails_mixins/custom_finder_methods.rb で実装している

```ruby
  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    model_class_rbi = root.create_class(self.model_class_name)
    model_relation_class_rbi = root.create_class(self.model_relation_class_name)
    model_assoc_proxy_class_rbi = root.create_class(self.model_assoc_proxy_class_name)
    model_assoc_relation_rbi = root.create_class(self.model_assoc_relation_class_name)

    custom_module_name = self.model_module_name("CustomFinderMethods")
    custom_module_rbi = root.create_module(custom_module_name)

    # and include the rbi module
    model_class_rbi.create_extend(custom_module_name)
    model_relation_class_rbi.create_include(custom_module_name)
    model_assoc_proxy_class_rbi.create_include(custom_module_name)
    model_assoc_relation_rbi.create_include(custom_module_name)

    custom_module_rbi.create_method(
      "first_n",
      parameters: [ Parameter.new("limit", type: "Integer") ],
      return_type: "T::Array[#{self.model_class_name}]",
    )

    custom_module_rbi.create_method(
      "last_n",
      parameters: [ Parameter.new("limit", type: "Integer") ],
      return_type: "T::Array[#{self.model_class_name}]",
    )

    custom_module_rbi.create_method(
      "find_n",
      parameters: [ Parameter.new("*args", type: "T::Array[T.any(Integer, String)]") ],
      return_type: "T::Array[#{self.model_class_name}]",
    )

    # allow common cases find_by_id
    custom_module_rbi.create_method(
      "find_by_id",
      parameters: [ Parameter.new("id", type: "T.nilable(Integer)") ],
      return_type: "T.nilable(#{self.model_class_name})",
    )
    custom_module_rbi.create_method(
      "find_by_id!",
      parameters: [ Parameter.new("id", type: "Integer") ],
      return_type: self.model_class_name,
    )
  end
```


## sorbet-rails/model_plugins/enumerable_collections.rb

https://github.com/chanzuckerberg/sorbet-rails/blob/master/lib/sorbet-rails/model_plugins/enumerable_collections.rb

```ruby
  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    model_assoc_proxy_class_rbi = root.create_class(self.model_assoc_proxy_class_name)

    # following methods only exists in an association proxy
    ["<<", "append", "push", "concat"].each do |method_name|
      elem = self.model_class_name
      model_assoc_proxy_class_rbi.create_method(
        method_name,
        parameters: [
          Parameter.new("*records", type: "T.any(#{elem}, T::Array[#{elem}])"),
        ],
        return_type: "T.self_type",
      )
    end
  end
```


## sorbet-rails/model_plugins/active_storage_methods.rb

https://railsguides.jp/active_storage_overview.html

```ruby

  sig { override.params(root: Parlour::RbiGenerator::Namespace).void }
  def generate(root)
    # Check that ActiveStorage the attachment_reflections method exists
    # It was added in 6.0, so it isn't available for 5.2.
    return unless defined?(@model_class.attachment_reflections) && @model_class.attachment_reflections.length > 0

    assoc_module_name = self.model_module_name("GeneratedAssociationMethods")
    assoc_module_rbi = root.create_module(assoc_module_name)

    attachment_reflections = @model_class.attachment_reflections.transform_values { |attachment| attachment.class }

    attachment_reflections.each do |assoc_name, attachment_type|
      if attachment_type.to_s == 'ActiveStorage::Reflection::HasOneAttachedReflection'
        create_has_one_methods(assoc_name, assoc_module_rbi)
      elsif attachment_type.to_s == 'ActiveStorage::Reflection::HasManyAttachedReflection'
        create_has_many_methods(assoc_name, assoc_module_rbi)
      end
    end
  end
```


