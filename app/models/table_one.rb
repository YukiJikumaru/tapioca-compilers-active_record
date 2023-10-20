# typed: true
class TableOne < ApplicationRecord
  def x
    non_existing_method_xxx
  end
end
