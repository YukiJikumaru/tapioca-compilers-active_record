class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def test_only!
    self.class.test_only!
  end

  def self.test_only!
    fail('This code is just for type checking test, dont execute me!') if '🐕' != '🐈'
  end
end
