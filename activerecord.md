
- [GeneratedAssociationMethods とは？](#generatedassociationmethods-とは)
  - [概要](#概要)
  - [実装場所](#実装場所)
  - [例：Siteの場合](#例siteの場合)
  - [例：Restaurantの例](#例restaurantの例)
  - [コード](#コード)
- [GeneratedAttributeMethodsとは？](#generatedattributemethodsとは)
  - [概要](#概要-1)
  - [実装](#実装)
    - [Read](#read)
    - [Write](#write)
    - [BeforeTypeCast](#beforetypecast)
    - [Query](#query)
    - [PrimaryKey](#primarykey)
    - [TimeZoneConversion](#timezoneconversion)
    - [Dirty](#dirty)
    - [Serialization](#serialization)


# GeneratedAssociationMethods とは？

## 概要

ActiveRecordのassociationを表現するもの
レコード毎にmoduleを動的に作成してincludeさせている

```ruby
pry(main)> Site.ancestors.map {|x|x.ancestors}.flatten.map { |x| x.to_s}.sort.uniq.grep /Generated/
=> ["ActiveRecord::Base::GeneratedAssociationMethods", # こっちは別
 "ActiveRecord::Base::GeneratedAttributeMethods",
 "ApplicationRecord::GeneratedAssociationMethods", # こっちは別
 "ApplicationRecord::GeneratedAttributeMethods",
 "Site::GeneratedAssociationMethods", # これ
 "Site::GeneratedAttributeMethods"]
```

```ruby
[16] pry(main)> Module.public_methods - ApplicationRecord.const_get(:GeneratedAssociationMethods).public_methods
=> [:nesting,
 :attr_internal_naming_format=,
 :attr_internal_naming_format,
 :used_modules,
 :used_refinements,
 :yaml_tag,
 :subclasses,
 :attached_object,
 :new,
 :class_attribute,
 :descendants,
 :json_creatable?,
 :superclass]

[13] pry(main)> Module.public_methods - ActiveRecord::Base.const_get(:GeneratedAssociationMethods).public_methods
=> [:nesting,
 :attr_internal_naming_format=,
 :attr_internal_naming_format,
 :used_modules,
 :used_refinements,
 :yaml_tag,
 :subclasses,
 :attached_object,
 :new,
 :class_attribute,
 :descendants,
 :json_creatable?,
 :superclass]
```

## 実装場所

```bash
x@hostname:~$ ls vendor/bundle/ruby/3.2.0/gems/activerecord-6.1.4.4/lib/active_record/associations/builder/
association.rb  belongs_to.rb  collection_association.rb  has_and_belongs_to_many.rb  has_many.rb  has_one.rb  singular_association.rb
```

## 例：Siteの場合

```ruby
pry(main)> Site.const_get(:GeneratedAssociationMethods).class
=> Module

[9] pry(main)> Site.const_get(:GeneratedAssociationMethods).instance_methods
=> [:fetch_past_reservation_ids, :fetch_past_reservations=, :fetch_past_reservation_ids=, :fetch_past_reservations]
```

```ruby
class Site < ApplicationRecord
  has_many :fetch_past_reservations
```
## 例：Restaurantの例


```ruby
[3] pry(main)> Restaurant.const_get(:GeneratedAssociationMethods).instance_methods.grep /prefecture/
=> [:prefecture, :prefecture=, :build_prefecture, :create_prefecture, :create_prefecture!, :reload_prefecture]
[5] pry(main)> Restaurant.const_get(:GeneratedAssociationMethods).instance_methods.grep /foo_feature_configuration/
=> [:foo_feature_configuration=,
 :build_foo_feature_configuration,
 :create_foo_feature_configuration,
 :create_foo_feature_configuration!,
 :reload_foo_feature_configuration,
 :foo_feature_configuration]
[6] pry(main)> Restaurant.const_get(:GeneratedAssociationMethods).instance_methods.grep /gbp_location/
=> [:gbp_location=, :reload_gbp_location, :gbp_location]
[7] pry(main)> Restaurant.const_get(:GeneratedAssociationMethods).instance_methods.grep /user_restaurants/
=> [:user_restaurants, :user_restaurants=]
[8] pry(main)> Restaurant.const_get(:GeneratedAssociationMethods).instance_methods.grep /users/
=> [:users, :users=]
```

```ruby
class Restaurant < ApplicationRecord # rubocop:disable Metrics/ClassLength
  extend T::Sig
  extend Enumerize
  include ModelRegex

  belongs_to :prefecture
  ........
  belongs_to :ledger, optional: true
  ........
  has_one :foo_feature_configuration
  .........
  has_one :gbp_location, through: :gbp_connection
  .........
  has_many :user_restaurants
  .........
  has_many :users, through: :user_restaurants
```

## コード

vendor/bundle/ruby/3.2.0/gems/activerecord-6.1.4.4/lib/active_record/core.rb

```ruby
module ActiveRecord
  module Core
    extend ActiveSupport::Concern

    module ClassMethods

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
    end
  end
end
```

vendor/bundle/ruby/3.2.0/gems/activerecord-6.1.4.4/lib/active_record/associations/builder/association.rb

```ruby
module ActiveRecord::Associations::Builder # :nodoc:
  class Association #:nodoc:
    def self.build(model, name, scope, options, &block)
      if model.dangerous_attribute_method?(name)
        raise ArgumentError, "You tried to define an association named #{name} on the model #{model.name}, but " \
                             "this will conflict with a method #{name} already defined by Active Record. " \
                             "Please choose a different association name."
      end

      reflection = create_reflection(model, name, scope, options, &block)
      define_accessors model, reflection
      define_callbacks model, reflection
      define_validations model, reflection
      reflection
    end
......................
    def self.create_reflection(model, name, scope, options, &block)
      raise ArgumentError, "association names must be a Symbol" unless name.kind_of?(Symbol)

      validate_options(options)

      extension = define_extensions(model, name, &block)
      options[:extend] = [*options[:extend], extension] if extension

      scope = build_scope(scope)

      ActiveRecord::Reflection.create(macro, name, scope, options, model)
    end
......................
    # Defines the setter and getter methods for the association
    # class Post < ActiveRecord::Base
    #   has_many :comments
    # end
    #
    # Post.first.comments and Post.first.comments= methods are defined by this method...
    def self.define_accessors(model, reflection)
      mixin = model.generated_association_methods
      name = reflection.name
      define_readers(mixin, name)
      define_writers(mixin, name)
    end

    def self.define_readers(mixin, name)
      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}
          association(:#{name}).reader
        end
      CODE
    end

    def self.define_writers(mixin, name)
      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}=(value)
          association(:#{name}).writer(value)
        end
      CODE
    end
```

# GeneratedAttributeMethodsとは？

```ruby
class Person < ApplicationRecord
  include ActiveModel::AttributeMethods

  attribute_method_affix prefix: "reset_", suffix: "_to_default!"
  attribute_method_prefix "first_", "last_"
  attribute_method_suffix "_short?"

  define_attribute_methods "name"
```

## 概要

```ruby
[24] pry(main)> Module.public_methods - Site.const_get(:GeneratedAttributeMethods).public_methods
=> [:nesting,
 :attr_internal_naming_format=,
 :attr_internal_naming_format,
 :used_modules,
 :used_refinements,
 :yaml_tag,
 :subclasses,
 :attached_object,
 :new,
 :class_attribute,
 :descendants,
 :json_creatable?,
 :superclass]
```

```ruby
[25] pry(main)> Module.public_methods - ApplicationRecord.const_get(:GeneratedAttributeMethods).public_methods
=> [:nesting,
 :attr_internal_naming_format=,
 :attr_internal_naming_format,
 :used_modules,
 :used_refinements,
 :yaml_tag,
 :subclasses,
 :attached_object,
 :new,
 :class_attribute,
 :descendants,
 :json_creatable?,
 :superclass]
```

```ruby
[27] pry(main)> Module.public_methods - ActiveRecord::Base.const_get(:GeneratedAttributeMethods).public_methods
=> [:nesting,
 :attr_internal_naming_format=,
 :attr_internal_naming_format,
 :used_modules,
 :used_refinements,
 :yaml_tag,
 :subclasses,
 :attached_object,
 :new,
 :class_attribute,
 :descendants,
 :json_creatable?,
 :superclass]
```

メソッドはない

## 実装

vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/active_record/attribute_methods.rb

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

    module ClassMethods
      def initialize_generated_modules # :nodoc:
        @generated_attribute_methods = const_set(:GeneratedAttributeMethods, GeneratedAttributeMethods.new)
        private_constant :GeneratedAttributeMethods
        @attribute_methods_generated = false
        @alias_attributes_mass_generated = false
        include @generated_attribute_methods

        super
      end

............

      # Declares the attributes that should be prefixed and suffixed by
      # <tt>ActiveModel::AttributeMethods</tt>.
      #
      # To use, pass attribute names (as strings or symbols). Be sure to declare
      # +define_attribute_methods+ after you define any prefix, suffix or affix
      # methods, or they will not hook in.
      #
      #   class Person
      #     include ActiveModel::AttributeMethods
      #
      #     attr_accessor :name, :age, :address
      #     attribute_method_prefix 'clear_'
      #
      #     # Call to define_attribute_methods must appear after the
      #     # attribute_method_prefix, attribute_method_suffix or
      #     # attribute_method_affix declarations.
      #     define_attribute_methods :name, :age, :address
      #
      #     private
      #
      #     def clear_attribute(attr)
      #       send("#{attr}=", nil)
      #     end
      #   end
      def define_attribute_methods(*attr_names)
        CodeGenerator.batch(generated_attribute_methods, __FILE__, __LINE__) do |owner|
          attr_names.flatten.each { |attr_name| define_attribute_method(attr_name, _owner: owner) }
        end
      end
```

vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/active_record/dynamic_matchers.rb

```ruby
module ActiveRecord
  module DynamicMatchers # :nodoc:
..................................
    private
      def respond_to_missing?(name, include_private = false)
        if self.class.define_attribute_methods
          # Some methods weren't defined yet.
          return true if self.class.method_defined?(name)
          return true if include_private && self.class.private_method_defined?(name)
        end

        super
      end

      def method_missing(name, ...) # ぜんぶここで呼ばれる
        # We can't know whether some method was defined or not because
        # multiple thread might be concurrently be in this code path.
        # So the first one would define the methods and the others would
        # appear to already have them.
        self.class.define_attribute_methods

        # So in all cases we must behave as if the method was just defined.
        method = begin
          self.class.public_instance_method(name)
        rescue NameError
          nil
        end

        # The method might be explicitly defined in the model, but call a generated
        # method with super. So we must resume the call chain at the right step.
        method = method.super_method while method && !method.owner.is_a?(GeneratedAttributeMethods)
        if method
          method.bind_call(self, ...)
        else
          super
        end
      end
```

```bash
$ grep -r DynamicMatchers vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/
vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/active_record/base.rb:    extend DynamicMatchers
```

```bash
x@hostname:~/tapioca-compilers-active_record$ ls vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/active_record/attribute_methods/
before_type_cast.rb  dirty.rb  primary_key.rb  query.rb  read.rb  serialization.rb  time_zone_conversion.rb  write.rb
```

### Read

vendor/bundle/ruby/3.2.0/gems/activerecord-7.1.1/lib/active_record/attribute_methods/read.rb





### Write
### BeforeTypeCast
### Query
### PrimaryKey
### TimeZoneConversion
### Dirty
### Serialization
