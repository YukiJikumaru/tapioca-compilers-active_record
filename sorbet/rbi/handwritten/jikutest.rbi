# typed: strong

# ActiveRecord::Result
# module ActiveRecord
#   class Promise < ::BasicObject
#     extend T::Generic
#
#     Elem = type_member { { fixed: T.untyped } }
#
#     sig { params(future_result: T.untyped, block: T.untyped).void }
#     def initialize(future_result, block); end
#
#     sig { returns(T::Class[Promise]) }
#     def class; end
#
#     sig { returns(::String) }
#     def inspect; end
#
#     sig { params(_arg0: T.class_of(Class)).returns(T::Boolean) }
#     def is_a?(_arg0); end
#
#     sig { returns(T::Boolean) }
#     def pending?; end
#
#     sig { params(q: T.untyped).returns(::String) }
#     def pretty_print(q); end
#
#     sig { params(_arg0: T.untyped).returns(T::Boolean) }
#     def respond_to?(*_arg0); end
#
#     sig { params(block: T.proc.params(arg: Elem).void).returns(T.self_type) }
#     def then(&block); end
#
#     sig { returns(Elem) }
#     def value; end
#
#     private
#
#     sig { returns(::Symbol) }
#     def status; end
#   end
# end
