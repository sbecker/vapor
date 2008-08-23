class Image < ActiveRecord::Base
  named_scope :public, :conditions => {:is_public => true}
  
  attr_accessible :name, :description
end
