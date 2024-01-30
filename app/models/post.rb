# typed: true
# HELLO I AM POST
class Post < ApplicationRecord
  belongs_to :author, optional: true
  has_many :post_tag_relations
  has_many :tags, through: :post_tag_relations

  attribute :price_in_cents, :integer

  alias_attribute :title_x, :title

  scope :id_n, ->(n) { where(id: n) }

  def test_select!
    test_only!

    # T.assert_type!(::Post.where(id: 0).select(:id), ::Post::ActiveRecord_Relation)
    relation = ::Post.where(id: 0).select(:id)
    T.assert_type!(::Post.where(id: 0).select_columns(:id), ::Post::ActiveRecord_Relation)
    # T.assert_type!(::Post.where(id: 0).select { |record| record.id == 1 }, T::Array[::Post])
    posts = ::Post.where(id: 0).select { |record| record.id == 1 }
    T.assert_type!(::Post.where(id: 0).filter { |record| record.id == 1 }, T::Array[::Post])
  end

  def test_attribute
    test_only!
    # T.assert_type!(price_in_cents, ::Integer)
  end

  def test_alias_attribute
    test_only!
    # T.assert_type!(title_x, ::String)
  end

  def test_where_not
    test_only!

    T.assert_type!(Post.where(id: 1).where.not(id: 1), ::Post::ActiveRecord_Relation)
  end

  def test_belongs_to_associations
    test_only!
    T.assert_type!(author, T.nilable(::Author))
    self.author = nil
    self.author = ::Author.new
    T.assert_type!(reload_author, T.nilable(::Author))

    T.assert_type!(build_author(), ::Author)
    T.assert_type!(build_author({}), ::Author)
    T.assert_type!(build_author({}) { |author| T.assert_type!(author, ::Author) }, ::Author)

    T.assert_type!(create_author(), T.nilable(::Author))
    T.assert_type!(create_author({}), T.nilable(::Author))
    T.assert_type!(create_author({}) { |author| T.assert_type!(author, ::Author) }, T.nilable(::Author))

    T.assert_type!(create_author!(), ::Author)
    T.assert_type!(create_author!({}), ::Author)
    T.assert_type!(create_author!({}) { |author| T.assert_type!(author, ::Author) }, ::Author)
  end

  def test_has_many_associations
    test_only!

    T.assert_type!(post_tag_relations, ::PostTagRelation::ActiveRecord_Associations_CollectionProxy)
    T.assert_type!(post_tag_relations.where(), ::PostTagRelation::ActiveRecord_Relation)
    T.assert_type!(post_tag_relations.where().to_a, T::Array[::PostTagRelation])
    T.assert_type!(post_tag_relation_ids, T::Array[[::Integer, ::Integer]])

    self.post_tag_relations = [::PostTagRelation.new]
    self.post_tag_relations << ::PostTagRelation.new

    post_tag_relations.build({})
    post_tag_relations.count

    T.assert_type!(tags, ::Tag::ActiveRecord_Associations_CollectionProxy)
    T.assert_type!(tags.where(), ::Tag::ActiveRecord_Relation)
    T.assert_type!(tags.where().to_a, T::Array[::Tag])
    T.assert_type!(tag_ids, T::Array[::Integer])

    self.tags = [::Tag.new]
    self.tags << ::PostTagRelation.new
  end
end
