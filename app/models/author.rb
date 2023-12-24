# typed: true
class Author < ApplicationRecord
  has_many :posts
end
