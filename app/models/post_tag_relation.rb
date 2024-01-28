# typed: true
#
# ```sql
# CREATE TABLE `post_tag_relations` (
#   `post_id` bigint(20) NOT NULL,
#   `tag_id` bigint(20) NOT NULL,
#   `created_at` datetime(6) NOT NULL,
#   `updated_at` datetime(6) NOT NULL,
#   PRIMARY KEY (`post_id`,`tag_id`),
#   KEY `index_post_tag_relations_on_post_id` (`post_id`),
#   KEY `index_post_tag_relations_on_tag_id` (`tag_id`),
#   CONSTRAINT `fk_rails_61d12ff146` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
#   CONSTRAINT `fk_rails_bf0b65a37e` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='post_tag_relations'
# ```
class PostTagRelation < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  # self.primary_key = [:post_id, :tag_id]

  def test_generated_attribute_methods
    test_only!

    T.assert_type!(id, [::Integer, ::Integer])
    T.assert_type!(post_id, ::Integer)
    T.assert_type!(tag_id, ::Integer)
  end

  def self.test_pk_finder_methods
    test_only!

    T.assert_type!(find([1, 1]), ::PostTagRelation)
    T.assert_type!(where(primary_key => [1, 1]), ::PostTagRelation::ActiveRecord_Relation)
  end
end
