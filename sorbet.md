# Tapioca RBI Extension API

tapioca-0.11.9/lib/tapioca/rbi_ext/model.rb

## Decalare a Module

```
sig { params(name: String, block: T.nilable(T.proc.params(scope: Scope).void)).returns(Scope) }
def create_module(name, &block)
```

```
module Spam
  def hello(your_name)
    "hello #{your_name}"
  end
end

module Spam
  # Return a greeting to your_name
  sig { params(your_name: ::String).returns(::String) }
  def hello(your_name); end
end

mod = scope.create_module('Spam')
mod.create_method(
  'hello',
  parameters: [create_param('your_name', type: '::String')],
  return_type: '::String',
  class_method: false,
  visibility: RBI::Public.new,
  comments: [RBI::Comment.new('Return a greeting to your_name')]
)
```

## Decalare a Class

```
sig do
  params(
    name: String,
    superclass_name: T.nilable(String),
    block: T.nilable(T.proc.params(scope: RBI::Scope).void),
  ).returns(Scope)
end
def create_class(name, superclass_name: nil, &block)
```

## Decalare a Constant

```
sig { params(name: String, value: String).void }
def create_constant(name, value:)
```

## Decalare include

```
sig { params(name: String).void }
def create_include(name)
```

## Decalare extend

```
sig { params(name: String).void }
def create_extend(name)
```

## --

```
sig { params(name: String).void }
def create_mixes_in_class_methods(name)
```

## Decalare a variable

```
sig do
  params(
    name: String,
    type: String,
    variance: Symbol,
    fixed: T.nilable(String),
    upper: T.nilable(String),
    lower: T.nilable(String),
  ).void
end
def create_type_variable(name, type:, variance: :invariant, fixed: nil, upper: nil, lower: nil)
```

## Decalare a Method

```
sig do
  params(
    name: String,
    parameters: T::Array[TypedParam],
    return_type: String,
    class_method: T::Boolean,
    visibility: RBI::Visibility,
    comments: T::Array[RBI::Comment],
  ).void
end
def create_method(name, parameters: [], return_type: "T.untyped", class_method: false, visibility: RBI::Public.new,
  comments: [])
```

### A parameter

```
def twice(num)
  num * 2
end

sig { params(num: ::Integer).returns(::Integer) }
def twice(num); end

scope.create_method('twice', parameters: [create_param('num', type: '::Integer')], return_type: '::Integer')
```

### Rest parameters

```
def sum(*nums)
  nums.sum
end

sig { params(nums: ::Integer).returns(::Integer) }
def sum(*nums); end

scope.create_method('sum', parameters: [create_rest_param('nums', type: '::Integer')], return_type: '::Integer')
```

### Optional parameters

### Block parameters


### Keyword Arguments

sig { params(name: String, type: String).returns(RBI::TypedParam) }
def create_kw_param(name, type:)
  create_typed_param(RBI::KwParam.new(name), type)
end

sig { params(name: String, type: String, default: String).returns(RBI::TypedParam) }
def create_kw_opt_param(name, type:, default:)
  create_typed_param(RBI::KwOptParam.new(name, default), type)
end

sig { params(name: String, type: String).returns(RBI::TypedParam) }
def create_kw_rest_param(name, type:)
  create_typed_param(RBI::KwRestParam.new(name), type)
end

