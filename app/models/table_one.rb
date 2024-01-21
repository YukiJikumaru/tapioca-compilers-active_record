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

  def inst
    # T.reveal_type id # NG
    # T.reveal_type string_non_null
    # T.reveal_type string_nullable
    # T.reveal_type integer_non_null
    # T.reveal_type integer_nullable
    # T.reveal_type created_at # NG
    # T.reveal_type updated_at # NG


    TableOne.first # NG
    TableOne.last # NG

    TableOne.select(:id) # TableOne::PrivateRelation

    # TableOne.where(id:0).class # TableOne::ActiveRecord_Relation
    TableOne.where(id: 0) # TableOne::PrivateRelationWhereChain
    TableOne.where(id: 0).first # NG
    TableOne.where(id: 0).second # NG
    TableOne.where(id: 0).last # NG
    TableOne.where(id: 0).update(name: 'NEW')

    # TableOne.where(id:0).joins(:test).class # TableOne::ActiveRecord_Relation
    TableOne.where(id: 0).joins(:test) # TableOne::PrivateRelation
    TableOne.where(id: 0).joins(:test).first

    # TableOne.joins(:test).class # TableOne::ActiveRecord_Relation
    TableOne.joins(:test) # TableOne::PrivateRelation

    # TableOne.includes(:test).class # TableOne::ActiveRecord_Relation
    TableOne.includes(:test) # TableOne::PrivateRelation



    # irb(main):026> TableOne.where(id:1).class
    # => TableOne::ActiveRecord_Relation
    # irb(main):027> TableOne.where.class
    # => ActiveRecord::QueryMethods::WhereChain

    # irb(main):037> TableOne.where(id: 0).class
    # => TableOne::ActiveRecord_Relation
    # irb(main):038> TableOne.where(id: 0).class.ancestors
    # =>
    # [TableOne::ActiveRecord_Relation,
    #  TableOne::GeneratedRelationMethods,

    # irb(main):040> TableOne.ancestors
    # =>
    # [TableOne(id: integer, string_non_null: string, string_nullable: string, integer_non_null: integer, integer_nullable: integer, created_at: datetime, updated_at: datetime),
    #  TableOne::GeneratedAssociationMethods,
    #  TableOne::GeneratedAttributeMethods,

    # irb(main):066> ObjectSpace.each_object(Class).to_a.map(&:to_s).grep /TableOne/
    # =>
    # [
    #  "TableOne::ActiveRecord_DisableJoinsAssociationRelation",
    #  "TableOne::ActiveRecord_AssociationRelation",
    #  "TableOne::ActiveRecord_Associations_CollectionProxy",
    #  "TableOne::ActiveRecord_Relation",
    #  "TableOne"]



    # ActiveRecord_AssociationRelation active_record/association_relation.rb
    # insert insert_all insert! insert_all! upsert upsert_all


    # active_record/model_schema.rb
    #--------------------------------------
    # def load_schema!
    #   unless table_name
    #     raise ActiveRecord::TableNotSpecified, "#{self} has no table configured. Set one with #{self}.table_name="
    #   end
    #   columns_hash = connection.schema_cache.columns_hash(table_name)
    #   columns_hash = columns_hash.except(*ignored_columns) unless ignored_columns.empty?
    #   @columns_hash = columns_hash.freeze
    #   @columns_hash.each do |name, column|
    #     type = connection.lookup_cast_type_from_column(column)
    #     type = _convert_type_from_options(type)
    #     define_attribute(
    #       name,
    #       type,
    #       default: column.default,
    #       user_provided_default: false
    #     )
    #     alias_attribute :id_value, :id if name == "id"
    #   end

    #   super
    # end
  end
end
