# typed: true
# HELLO I AM POST
class Post < ApplicationRecord
  belongs_to :author, optional: true
  has_many :post_tag_relations
  has_many :tags, through: :post_tag_relations

  attribute :price_in_cents, :integer

  alias_attribute :title_x, :title


end
