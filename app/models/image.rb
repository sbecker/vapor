class Image < ActiveRecord::Base
  # would just use "public" but this causes weird nil.call errors in rspec - SMB 8/22/08
  # see http://www.nabble.com/Mysterious-interaction-between-RSpec-1.1.4-and-has_finder-named_scope-tt17810058.html#a17810058
  named_scope :all_public,  :conditions => {:is_public => true}
  named_scope :all_private, :conditions => {:is_public => false}
  named_scope :available,   :conditions => {:state     => 'available'}

  attr_accessible :name, :description
end
