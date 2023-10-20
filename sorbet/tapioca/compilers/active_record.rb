# typed: ignore

module Tapioca
  module Compilers
    class ActiveRecord < Tapioca::Dsl::Compiler
      extend T::Sig

      ConstantType = type_member {{ fixed: ::T.class_of(::Enumerize::Base) }}

      sig { override.returns(::T::Enumerable[Module]) }
      def self.gather_constants
        # classes = all_classes.select { |c| c < ::Enumerize::Base }
        # modules = all_modules.select { |c| c != ::Enumerize::Base && c.ancestors.any? { |x| x.equal?(::Enumerize::Base) } }
        # classes + modules
        []
      end

      sig { override.void }
      def decorate
        root.create_path(constant) do |klass|
          constant.enumerized_attributes.attributes.each do |attribute_name, attribute|
            # Restaurant.status
            ######################################################
            enumerize_class_attribute = "::Enumerize#{constant.name}#{attribute_name.camelize}ClassAttribute"
            root.create_class(enumerize_class_attribute, superclass_name: '::Enumerize::Attribute') do |mod|
              # Restaurant.status.{active,suspended,inactive}
              attribute.values.each do |v|
                mod.create_method(v, return_type: '::Enumerize::Value')
              end
            end
            klass.create_method(attribute_name, return_type: enumerize_class_attribute, class_method: true)

            ar_type = constant.respond_to?(:columns_hash) ? constant.columns_hash[attribute_name]&.type : nil

            # rst.status
            ######################################################
            enumerize_instance_value = "#{constant.name}#{attribute_name.camelize}InstanceValue"
            root.create_class(enumerize_instance_value, superclass_name: '::Enumerize::Value') do |mod|
              # rst.status.{active?,suspended?,inactive?}
              attribute.values.each do |v|
                mod.create_method("#{v}?", return_type: '::T::Boolean')
              end
            end
            klass.create_method(attribute_name, return_type: enumerize_instance_value)

            # rst.status=()
            ######################################################
            klass.create_method(
              "#{attribute_name}=",
              parameters: [create_param('value', type: ar_type2sorbet_type(ar_type, true))],
              return_type: 'void',
            )

            # rst.status_text
            ######################################################
            klass.create_method("#{attribute_name}_text", return_type: '::String')
            # rst.status_value
            ######################################################
            klass.create_method("#{attribute_name}_value", return_type: ar_type2sorbet_type(ar_type))
          end
        end
      end
    end
  end
end
