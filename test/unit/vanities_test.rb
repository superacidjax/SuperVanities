require 'rubygems'
require 'test/unit'
require 'active_record'
require 'sqlite3'
require File.expand_path("../../../lib/vanities", __FILE__)
require File.expand_path("../../../lib/generators/vanities/templates/vanity.rb", __FILE__)

# Clean up any existing sqlite3 db if it exists
old_db_file = "vanities_test.sqlite3"
if File.exists?(old_db_file)
  File.delete(old_db_file)
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "vanities_test.sqlite3")
ActiveRecord::Schema.define :version => 1 do
  create_table :posts do |t|
    t.string :title
  end
end

ActiveRecord::Schema.define :version => 2 do
  create_table :vanities do |t|
    t.string      :name
    t.integer     :vain_id
    t.string      :vain_type
  end
end

class Post < ActiveRecord::Base
  has_vanity
end

class VanitiesTest < Test::Unit::TestCase
  def test_has_vanity_loaded_in_new_ar_object
    # Attempt to create (and thereby save) a new post
    assert (@post = Post.create(:title => "blah"))

    # Right now the number of vanities that exist should be zero.
    assert Vanity.count == 0

    # See if that post responds to the "vanity" getter
    assert @post.respond_to?(:vanity)

    # And see if we can set it to a new vanity
    assert (@post.vanity = Vanity.new(:name => "foo"))

    # And now that a vanity has been created, we should have exactly 1 vanity.
    assert Vanity.count == 1

    # Now if we call @post.vanity we should get the one we just created
    assert @post.vanity == Vanity.first
  end
end