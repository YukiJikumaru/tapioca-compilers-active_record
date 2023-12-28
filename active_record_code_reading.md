
Class.new(String).include(Class.new(Module).new)



```
Post.ancestors
[Post(id: integer, author_id: integer, title: string, content: text, created_at: datetime, updated_at: datetime),
 Post::GeneratedAssociationMethods,
 Post::GeneratedAttributeMethods,
 ApplicationRecord(abstract),

 ApplicationRecord::GeneratedAssociationMethods,
 ApplicationRecord::GeneratedAttributeMethods,

 ActiveRecord::Base,
 ActiveRecord::Marshalling::Methods,
 ActiveRecord::Normalization,
 ActiveRecord::Suppressor,
 ActiveRecord::SignedId,
 ActiveRecord::TokenFor,
 ActiveRecord::SecureToken,
 ActiveRecord::Store,
 ActiveRecord::Serialization,

 ActiveRecord::Reflection,
 ActiveRecord::NoTouching,
 ActiveRecord::TouchLater,
 ActiveRecord::Transactions,
 ActiveRecord::NestedAttributes,
 ActiveRecord::AutosaveAssociation,
 ActiveRecord::SecurePassword,
 ActiveModel::SecurePassword,
 ActiveRecord::Associations,
 ActiveRecord::Timestamp,

 ActiveRecord::AttributeMethods::Serialization,
 ActiveRecord::AttributeMethods::Dirty,
 ActiveModel::Dirty,
 ActiveRecord::AttributeMethods::TimeZoneConversion,
 ActiveRecord::AttributeMethods::PrimaryKey,
 ActiveRecord::AttributeMethods::Query,
 ActiveRecord::AttributeMethods::BeforeTypeCast,
 ActiveRecord::AttributeMethods::Write,
 ActiveRecord::AttributeMethods::Read,
 ActiveRecord::Base::GeneratedAssociationMethods,
 ActiveRecord::Base::GeneratedAttributeMethods,
 ActiveRecord::AttributeMethods,
 ActiveModel::AttributeMethods,
 ActiveRecord::Encryption::EncryptableRecord,
 ActiveRecord::Locking::Pessimistic,
 ActiveRecord::Locking::Optimistic,
 ActiveRecord::Attributes,
 ActiveRecord::CounterCache,
 ActiveRecord::Validations,

 ActiveSupport::Callbacks,

 ActiveRecord::Integration,
 ActiveModel::Conversion,
 ActiveRecord::AttributeAssignment,
 ActiveModel::AttributeAssignment,
 ActiveModel::ForbiddenAttributesProtection,
 ActiveRecord::Sanitization,
 ActiveRecord::Scoping::Named,
 ActiveRecord::Scoping::Default,
 ActiveRecord::Scoping,
 ActiveRecord::Inheritance,
 ActiveRecord::ModelSchema,
 ActiveRecord::ReadonlyAttributes,
 ActiveRecord::Persistence,
 ActiveRecord::Core,
 ActiveModel::Access,

 Kernel,
 BasicObject]
```


# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/railtie.rb

[🐵1] エントリーポイント

```ruby
require "active_record" # [🐵2-A]

module ActiveRecord
  class Railtie < Rails::Railtie

    runner do
      require "active_record/base" # [🐵3-A]
    end

    initializer "active_record.define_attribute_methods" do |app|

              descendants.each do |model|
                if model.connection_pool.schema_reflection.cached?(model.table_name)
                  model.define_attribute_methods [🐵4-A]
                end
              end

    initializer "active_record.initialize_database" do
      ActiveSupport.on_load(:active_record) do
        self.configurations = Rails.application.config.database_configuration

        establish_connection
      end
    end
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record.rb

```ruby
[🐵2-B]
module ActiveRecord
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Callbacks
  autoload :ConnectionHandling
  autoload :Core
  autoload :CounterCache
  autoload :DelegatedType
  autoload :DestroyAssociationAsyncJob
  autoload :DynamicMatchers
  autoload :Encryption
  autoload :Enum
  autoload :Explain
  autoload :FixtureSet, "active_record/fixtures"
  autoload :Inheritance
  autoload :Integration
  autoload :InternalMetadata
  autoload :LogSubscriber
  autoload :Marshalling
  autoload :Migration
  autoload :Migrator, "active_record/migration"
  autoload :ModelSchema
  autoload :NestedAttributes
  autoload :NoTouching
  autoload :Normalization
  autoload :Persistence
  autoload :QueryCache
  autoload :QueryLogs
  autoload :Querying
  autoload :ReadonlyAttributes
  autoload :RecordInvalid, "active_record/validations"
  autoload :Reflection
  autoload :RuntimeRegistry
  autoload :Sanitization
  autoload :Schema
  autoload :SchemaDumper
  autoload :SchemaMigration
  autoload :Scoping
  ...............
  eager_autoload do
    autoload :Aggregations
    autoload :AssociationRelation
    autoload :Associations
    autoload :AsynchronousQueriesTracker
    autoload :AttributeAssignment
    autoload :AttributeMethods
    autoload :AutosaveAssociation
    autoload :ConnectionAdapters
    autoload :DisableJoinsAssociationRelation
    autoload :FutureResult
    autoload :LegacyYamlAdapter
    autoload :Promise
    autoload :Relation
    autoload :Result
    autoload :StatementCache
    autoload :TableMetadata
    autoload :Type

    autoload_under "relation" do
      autoload :Batches
      autoload :Calculations
      autoload :Delegation
      autoload :FinderMethods
      autoload :PredicateBuilder
      autoload :QueryMethods
      autoload :SpawnMethods
    end
  end
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/base.rb

[🐵3-B]

```ruby
module ActiveRecord
  class Base
    extend ActiveModel::Naming

    extend ActiveSupport::Benchmarkable
    extend ActiveSupport::DescendantsTracker

    extend ConnectionHandling
    extend QueryCache::ClassMethods
    extend Querying # [🐵3-I] 🎂🍩🍰🧁🍨
    extend Translation
    extend DynamicMatchers
    extend DelegatedType
    extend Explain
    extend Enum
    extend Delegation::DelegateCache 🎂🍩🍰🧁🍨
    extend Aggregations::ClassMethods

    include Core # [🐵3-C]
    include Persistence # [🐵3-D]
    include ReadonlyAttributes
    include ModelSchema # [🐵3-E]
    include Inheritance
    include Scoping
    include Sanitization
    include AttributeAssignment
    include ActiveModel::Conversion
    include Integration
    include Validations
    include CounterCache
    include Attributes # [🐵3-F]
    include Locking::Optimistic
    include Locking::Pessimistic
    include Encryption::EncryptableRecord
    include AttributeMethods # [🐵3-G]
    include Callbacks
    include Timestamp
    include Associations # [🐵3-H]
    include SecurePassword
    include AutosaveAssociation
    include NestedAttributes
    include Transactions
    include TouchLater
    include NoTouching
    include Reflection
    include Serialization
    include Store
    include SecureToken
    include TokenFor
    include SignedId
    include Suppressor
    include Normalization
    include Marshalling::Methods
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/core.rb

[🐵3-C-1]

```ruby
module ActiveRecord
  # = Active Record \Core
  module Core
    extend ActiveSupport::Concern
    include ActiveModel::Access
.......................
    module ClassMethods

      def find(*ids) # :nodoc:
      def find_by(*args) # :nodoc:
      def find_by!(*args) # :nodoc:

      def initialize_generated_modules # :nodoc:
        generated_association_methods
      end

      def generated_association_methods # :nodoc:
        @generated_association_methods ||= begin
          mod = const_set(:GeneratedAssociationMethods, Module.new)
          private_constant :GeneratedAssociationMethods
          include mod

          mod
        end
      end
.........................
    end
.........................
    # New objects can be instantiated as either empty (pass no construction parameter) or pre-set with
    # attributes but not yet saved (pass a hash with key names matching the associated table column names).
    # In both instances, valid attribute keys are determined by the column names of the associated table --
    # hence you can't have attributes that aren't part of the table columns.
    #
    # ==== Example
    #   # Instantiates a single new object
    #   User.new(first_name: 'Jamie')
    def initialize(attributes = nil)
      @new_record = true
      @attributes = self.class._default_attributes.deep_dup

      init_internals
      initialize_internals_callback

      assign_attributes(attributes) if attributes

      yield self if block_given?
      _run_initialize_callbacks
    end
.........................
    private
      # +Array#flatten+ will call +#to_ary+ (recursively) on each of the elements of
      # the array, and then rescues from the possible +NoMethodError+. If those elements are
      # +ActiveRecord::Base+'s, then this triggers the various +method_missing+'s that we have,
      # which significantly impacts upon performance.
      #
      # So we can avoid the +method_missing+ hit by explicitly defining +#to_ary+ as +nil+ here.
      #
      # See also https://tenderlovemaking.com/2011/06/28/til-its-ok-to-return-nil-from-to_ary.html
      def to_ary
        nil
      end
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/persistence.rb

[🐵3-D-1]

```ruby
require "active_record/insert_all"

module ActiveRecord
  # = Active Record \Persistence
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
............
      def create(attributes = nil, &block)
      def create!(attributes = nil, &block)
      def build(attributes = nil, &block)
      def insert(attributes, returning: nil, unique_by: nil, record_timestamps: nil)
      def insert_all(attributes, returning: nil, unique_by: nil, record_timestamps: nil)
      def insert!(attributes, returning: nil, record_timestamps: nil)
      def insert_all!(attributes, returning: nil, record_timestamps: nil)
      def upsert(attributes, **kwargs)
      def upsert_all(attributes, on_duplicate: :update, update_only: nil, returning: nil, unique_by: nil, record_timestamps: nil)
      def instantiate(attributes, column_types = {}, &block)
      def update(id = :all, attributes)
      def update!(id = :all, attributes)
      def query_constraints(*columns_list)
      def has_query_constraints? # :nodoc:
      def query_constraints_list
      def composite_query_constraints_list # :nodoc:
      def destroy(id)
      def delete(id_or_array)
......................
    def new_record?
    def previously_new_record?
    def destroyed?
    def persisted?
    def save(**options, &block)
    def save!(**options, &block)
    def delete
    def destroy
    def becomes(klass)
    def becomes!(klass)
    def update_attribute(name, value)
    def update_attribute!(name, value)
    def update(attributes)
    def update!(attributes)
    def update_column(name, value)
    def update_columns(attributes)
    def increment(attribute, by = 1)
    def increment!(attribute, by = 1, touch: nil)
    def decrement(attribute, by = 1)
    def decrement!(attribute, by = 1, touch: nil)
    def toggle(attribute)
    def toggle!(attribute)
    def reload(options = nil)
    def touch(*names, time: nil)

```



# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/model_schema.rb

[🐵3-E-1]

```ruby
module ActiveRecord
  # = Active Record Attribute Methods
  module AttributeMethods
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      initialize_generated_modules
      include Read
      include Write
      include BeforeTypeCast
      include Query
      include PrimaryKey
      include TimeZoneConversion
      include Dirty
      include Serialization
    end

    class GeneratedAttributeMethods < Module # :nodoc:
      include Mutex_m
    end
..................
    module ClassMethods
      def initialize_generated_modules # :nodoc:
        @generated_attribute_methods = const_set(:GeneratedAttributeMethods, GeneratedAttributeMethods.new)
        private_constant :GeneratedAttributeMethods
        @attribute_methods_generated = false
        @alias_attributes_mass_generated = false
        include @generated_attribute_methods

        super
      end
..................
      # Generates all the attribute related methods for columns in the database
      # accessors, mutators and query methods.
      def define_attribute_methods # :nodoc:
        return false if @attribute_methods_generated
        # Use a mutex; we don't want two threads simultaneously trying to define
        # attribute methods.
        generated_attribute_methods.synchronize do
          return false if @attribute_methods_generated
          superclass.define_attribute_methods unless base_class?
          super(attribute_names)
          @attribute_methods_generated = true
        end
      end
..................
      private
        def inherited(child_class)
          super
          child_class.initialize_generated_modules
          child_class.class_eval do
            @alias_attributes_mass_generated = false
            @attribute_names = nil
          end
        end
    end
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/attribute.rb

[🐵3-F-1]

```ruby
module ActiveRecord
  # See ActiveRecord::Attributes::ClassMethods for documentation
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes_to_define_after_schema_loads, instance_accessor: false, default: {} # :internal:
    end
    # = Active Record \Attributes
    module ClassMethods
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/attribute_methods.rb

[🐵3-E-1]

```ruby
module ActiveRecord
  module ModelSchema
    extend ActiveSupport::Concern
.....................
      def load_schema # :nodoc:
        return if schema_loaded?
        @load_schema_monitor.synchronize do
          return if @columns_hash

          load_schema!

          @schema_loaded = true
        rescue
          reload_schema_from_cache # If the schema loading failed half way through, we must reset the state.
          raise
        end
      end
.....................
      private
.....................
        def load_schema!
          unless table_name
            raise ActiveRecord::TableNotSpecified, "#{self} has no table configured. Set one with #{self}.table_name="
          end

          columns_hash = connection.schema_cache.columns_hash(table_name)
          columns_hash = columns_hash.except(*ignored_columns) unless ignored_columns.empty?
          @columns_hash = columns_hash.freeze
          @columns_hash.each do |name, column|
            type = connection.lookup_cast_type_from_column(column)
            type = _convert_type_from_options(type)
            define_attribute(
              name,
              type,
              default: column.default,
              user_provided_default: false
            )
            alias_attribute :id_value, :id if name == "id"
          end

          super
        end
.....................
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/associations.rb

[🐵3-H-1]

```ruby
module ActiveRecord
........
  # See ActiveRecord::Associations::ClassMethods for documentation.
  module Associations # :nodoc:
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    # These classes will be loaded when associations are created.
    # So there is no need to eager load them.
    autoload :Association
    autoload :SingularAssociation
    autoload :CollectionAssociation
    autoload :ForeignAssociation
    autoload :CollectionProxy
    autoload :ThroughAssociation

    module Builder # :nodoc:
      autoload :Association,           "active_record/associations/builder/association"
      autoload :SingularAssociation,   "active_record/associations/builder/singular_association"
      autoload :CollectionAssociation, "active_record/associations/builder/collection_association"

      autoload :BelongsTo,           "active_record/associations/builder/belongs_to"
      autoload :HasOne,              "active_record/associations/builder/has_one"
      autoload :HasMany,             "active_record/associations/builder/has_many"
      autoload :HasAndBelongsToMany, "active_record/associations/builder/has_and_belongs_to_many"
    end

    eager_autoload do
      autoload :BelongsToAssociation
      autoload :BelongsToPolymorphicAssociation
      autoload :HasManyAssociation
      autoload :HasManyThroughAssociation
      autoload :HasOneAssociation
      autoload :HasOneThroughAssociation

      autoload :Preloader
      autoload :JoinDependency
      autoload :AssociationScope
      autoload :DisableJoinsAssociationScope
      autoload :AliasTracker
    end
```

# vendor/bundle/ruby/3.0.0/gems/activerecord-7.1.1/lib/active_record/querying.rb

[🐵3-I-1]

```ruby
module ActiveRecord
  module Querying 🎂🍩🍰🧁🍨
    QUERYING_METHODS = [
      :find, :find_by, :find_by!, :take, :take!, :sole, :find_sole_by, :first, :first!, :last, :last!,
      :second, :second!, :third, :third!, :fourth, :fourth!, :fifth, :fifth!,
      :forty_two, :forty_two!, :third_to_last, :third_to_last!, :second_to_last, :second_to_last!,
      :exists?, :any?, :many?, :none?, :one?,
      :first_or_create, :first_or_create!, :first_or_initialize,
      :find_or_create_by, :find_or_create_by!, :find_or_initialize_by,
      :create_or_find_by, :create_or_find_by!,
      :destroy_all, :delete_all, :update_all, :touch_all, :destroy_by, :delete_by,
      :find_each, :find_in_batches, :in_batches,
      :select, :reselect, :order, :regroup, :in_order_of, :reorder, :group, :limit, :offset, :joins, :left_joins, :left_outer_joins,
      :where, :rewhere, :invert_where, :preload, :extract_associated, :eager_load, :includes, :from, :lock, :readonly,
      :and, :or, :annotate, :optimizer_hints, :extending,
      :having, :create_with, :distinct, :references, :none, :unscope, :merge, :except, :only,
      :count, :average, :minimum, :maximum, :sum, :calculate,
      :pluck, :pick, :ids, :async_ids, :strict_loading, :excluding, :without, :with,
      :async_count, :async_average, :async_minimum, :async_maximum, :async_sum, :async_pluck, :async_pick,
    ].freeze # :nodoc:
    delegate(*QUERYING_METHODS, to: :all) # [🐵3-I-2] 🎂🍩🍰🧁🍨

    def find_by_sql(sql, binds = [], preparable: nil, &block)
    def async_find_by_sql(sql, binds = [], preparable: nil, &block)
```

scoping/named.rb

```ruby
module ActiveRecord
  # = Active Record \Named \Scopes
  module Scoping
    module Named
      extend ActiveSupport::Concern

      module ClassMethods
        # Returns an ActiveRecord::Relation scope object.
        #
        #   posts = Post.all
        #   posts.size # Fires "select count(*) from  posts" and returns the count
        #   posts.each {|p| puts p.name } # Fires "select * from posts" and loads post objects
        #
        #   fruits = Fruit.all
        #   fruits = fruits.where(color: 'red') if options[:red_only]
        #   fruits = fruits.limit(10) if limited?
        #
        # You can define a scope that applies to all finders using
        # {default_scope}[rdoc-ref:Scoping::Default::ClassMethods#default_scope].
        def all(all_queries: nil) # [🐵3-I-3] 🎂🍩🍰🧁🍨
          scope = current_scope

          if scope
            if self == scope.klass
              scope.clone
            else
              relation.merge!(scope)
            end
          else
            default_scoped(all_queries: all_queries)
          end
        end
..................
        # Returns a scope for the model with default scopes.
        def default_scoped(scope = relation, all_queries: nil)
          build_default_scope(scope, all_queries: all_queries) || scope # [🐵3-I-4] 🎂🍩🍰🧁🍨
        end
```

scoping/default.rb

```ruby
module ActiveRecord
  module Scoping
.............
    module Default
      extend ActiveSupport::Concern
.............
      module ClassMethods
.............
        private
.............
          def build_default_scope(relation = relation(), all_queries: nil)
            return if abstract_class?

            if default_scope_override.nil?
              self.default_scope_override = !Base.is_a?(method(:default_scope).owner)
            end

            if default_scope_override
              # The user has defined their own default scope method, so call that
              evaluate_default_scope do
                relation.scoping { default_scope } # [🐵3-I-5] 🎂🍩🍰🧁🍨
              end
            elsif default_scopes.any?
              evaluate_default_scope do
                default_scopes.inject(relation) do |combined_scope, scope_obj| # [🐵3-I-5] 🎂🍩🍰🧁🍨
                  if execute_scope?(all_queries, scope_obj)
                    scope = scope_obj.scope.respond_to?(:to_proc) ? scope_obj.scope : scope_obj.scope.method(:call)

                    combined_scope.instance_exec(&scope) || combined_scope
                  else
                    combined_scope
                  end
                end
              end
            end
          end
```

active_record/core.rb

```ruby
module ActiveRecord
  # = Active Record \Core
  module Core
    extend ActiveSupport::Concern
...............
    module ClassMethods
...............
      private
...............
        def relation # [🐵3-I-6]
          relation = Relation.create(self) 🎂🍩🍰🧁🍨

          if finder_needs_type_condition? && !ignore_default_scope?
            relation.where!(type_condition)
          else
            relation
          end
        end
```

active_record/relation.rb

```ruby
module ActiveRecord
  # = Active Record \Relation
  class Relation 🎂🍩🍰🧁🍨
    MULTI_VALUE_METHODS  = [:includes, :eager_load, :preload, :select, :group,
                            :order, :joins, :left_outer_joins, :references,
                            :extending, :unscope, :optimizer_hints, :annotate,
                            :with]

    SINGLE_VALUE_METHODS = [:limit, :offset, :lock, :readonly, :reordering, :strict_loading,
                            :reverse_order, :distinct, :create_with, :skip_query_cache]

    CLAUSE_METHODS = [:where, :having, :from]
    INVALID_METHODS_FOR_DELETE_ALL = [:distinct, :with]

    VALUE_METHODS = MULTI_VALUE_METHODS + SINGLE_VALUE_METHODS + CLAUSE_METHODS

    include Enumerable
    include FinderMethods, Calculations, SpawnMethods, QueryMethods, Batches, Explain, Delegation 🎂🍩🍰🧁🍨
```

active_record/relation/delegation.rb

```ruby
# frozen_string_literal: true

require "mutex_m"
require "active_support/core_ext/module/delegation"

module ActiveRecord
  module Delegation # :nodoc:
    class << self
      def delegated_classes
        [
          ActiveRecord::Relation,
          ActiveRecord::Associations::CollectionProxy,
          ActiveRecord::AssociationRelation,
          ActiveRecord::DisableJoinsAssociationRelation,
        ]
      end

      def uncacheable_methods
        @uncacheable_methods ||= (
          delegated_classes.flat_map(&:public_instance_methods) - ActiveRecord::Relation.public_instance_methods
        ).to_set.freeze
      end
    end

    module DelegateCache # :nodoc:
      def relation_delegate_class(klass)
        @relation_delegate_cache[klass]
      end

      def initialize_relation_delegate_cache
        @relation_delegate_cache = cache = {}
        Delegation.delegated_classes.each do |klass|
          delegate = Class.new(klass) {
            include ClassSpecificRelation
          }
          include_relation_methods(delegate)
          mangled_name = klass.name.gsub("::", "_")
          const_set mangled_name, delegate
          private_constant mangled_name

          cache[klass] = delegate
        end
      end

      def inherited(child_class)
        child_class.initialize_relation_delegate_cache 🎂🍩🍰🧁🍨
        super
      end

      def generate_relation_method(method) 🎂🍩🍰🧁🍨
        generated_relation_methods.generate_method(method)
      end

      protected
        def include_relation_methods(delegate)
          superclass.include_relation_methods(delegate) unless base_class?
          # ?????????????????????????????????????????????????
          # Class.new(String).include(Class.new(Module).new)
          # ?????????????????????????????????????????????????
          delegate.include generated_relation_methods
        end

      private
        def generated_relation_methods
          @generated_relation_methods ||= GeneratedRelationMethods.new.tap do |mod|
            const_set(:GeneratedRelationMethods, mod)
            private_constant :GeneratedRelationMethods
          end
        end
    end

    class GeneratedRelationMethods < Module # :nodoc:
      include Mutex_m

      def generate_method(method) 🎂🍩🍰🧁🍨
        synchronize do
          return if method_defined?(method)

          if /\A[a-zA-Z_]\w*[!?]?\z/.match?(method) && !DELEGATION_RESERVED_METHOD_NAMES.include?(method.to_s)
            module_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{method}(...)
                scoping { klass.#{method}(...) }
              end
            RUBY
          else
            define_method(method) do |*args, &block|
              scoping { klass.public_send(method, *args, &block) }
            end
            ruby2_keywords(method)
          end
        end
      end
    end
    private_constant :GeneratedRelationMethods

    extend ActiveSupport::Concern

    # This module creates compiled delegation methods dynamically at runtime, which makes
    # subsequent calls to that method faster by avoiding method_missing. The delegations
    # may vary depending on the klass of a relation, so we create a subclass of Relation
    # for each different klass, and the delegations are compiled into that subclass only.

    delegate :to_xml, :encode_with, :length, :each, :join, :intersect?,
             :[], :&, :|, :+, :-, :sample, :reverse, :rotate, :compact, :in_groups, :in_groups_of,
             :to_sentence, :to_fs, :to_formatted_s, :as_json,
             :shuffle, :split, :slice, :index, :rindex, to: :records

    delegate :primary_key, :connection, to: :klass

    module ClassSpecificRelation # :nodoc: 🎂🍩🍰🧁🍨
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def name
          superclass.name
        end
      end

      private
        def method_missing(method, *args, &block)
          if @klass.respond_to?(method)
            unless Delegation.uncacheable_methods.include?(method)
              @klass.generate_relation_method(method) 🎂🍩🍰🧁🍨
            end
            scoping { @klass.public_send(method, *args, &block) }
          else
            super
          end
        end
        ruby2_keywords(:method_missing)
    end

    module ClassMethods # :nodoc:
      def create(klass, *args, **kwargs)
        relation_class_for(klass).new(klass, *args, **kwargs)
      end

      private
        def relation_class_for(klass)
          klass.relation_delegate_class(self)
        end
    end

    private
      def respond_to_missing?(method, _)
        super || @klass.respond_to?(method)
      end
  end
end

```







```ruby

class GeneratedRelationMethods < Module
end

module ClassSpecificRelation
end

module DelegateCache
  def initialize_relation_delegate_cache
    @relation_delegate_cache = cache = {}
    [ActiveRecord::Relation, ActiveRecord::Associations::CollectionProxy].each do |klass|
      delegate = Class.new(klass) {
        include ClassSpecificRelation
      }
      # include_relation_methods(delegate)
      delegate.include generated_relation_methods

      mangled_name = klass.name.gsub("::", "_")
      const_set mangled_name, delegate
      private_constant mangled_name
      cache[klass] = delegate
    end
  end

  def inherited(child_class)
    puts "inherited by #{child_class}"
    child_class.initialize_relation_delegate_cache
    super
  end

  def generated_relation_methods
    @generated_relation_methods ||= GeneratedRelationMethods.new.tap do |mod|
      const_set(:GeneratedRelationMethods, mod)
      private_constant :GeneratedRelationMethods
    end
  end
end

class Hoge
  extend DelegateCache

  def ccc
    @relation_delegate_cache
  end
end
```




class GeneratedRelationMethods < Module # :nodoc:
  include Mutex_m

  def generate_method(method) 🎂🍩🍰🧁🍨
    synchronize do
      return if method_defined?(method)

      if /\A[a-zA-Z_]\w*[!?]?\z/.match?(method) && !DELEGATION_RESERVED_METHOD_NAMES.include?(method.to_s)
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(...)
            scoping { klass.#{method}(...) }
          end
        RUBY
      else
        define_method(method) do |*args, &block|
          scoping { klass.public_send(method, *args, &block) }
        end
        ruby2_keywords(method)
      end
    end
  end
end

[
  ActiveRecord::Relation,
  ActiveRecord::Associations::CollectionProxy,
  ActiveRecord::AssociationRelation,
  ActiveRecord::DisableJoinsAssociationRelation,
].each do |klass|
  delegate = Class.new(klass) { include ClassSpecificRelation }
  delegate.include(GeneratedRelationMethods.new)
end



Post::ActiveRecord_Relation extends (ActiveRecord::Relation include GeneratedRelationMethods)
Post::ActiveRecord_Associations_CollectionProxy extends (ActiveRecord::Associations::CollectionProxy include GeneratedRelationMethods)
Post::ActiveRecord_AssociationRelation extends (ActiveRecord::AssociationRelation include GeneratedRelationMethods)
Post::ActiveRecord_DisableJoinsAssociationRelation extends (ActiveRecord::DisableJoinsAssociationRelation include GeneratedRelationMethods)



