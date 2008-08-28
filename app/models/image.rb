class Image < ActiveRecord::Base
  # would just use "public" but this causes weird nil.call errors in rspec - SMB 8/22/08
  # see http://www.nabble.com/Mysterious-interaction-between-RSpec-1.1.4-and-has_finder-named_scope-tt17810058.html#a17810058
  named_scope :all_public,  :order => 'location', :conditions => {:is_public => true}
  named_scope :all_private, :order => 'location', :conditions => {:is_public => false}
  named_scope :available,   :order => 'location', :conditions => {:state     => 'available'}

  attr_accessible :name, :description

  def self.others(account_id)
    all(:conditions => "(account_id != #{account_id} OR account_id IS NULL)" +
                       " AND owner_id != '#{Account::Vendors::Alestic}'"     +
                       " AND owner_id != '#{Account::Vendors::Amazon}'"      +
                       " AND owner_id != '#{Account::Vendors::RBuilder}'"    +
                       " AND owner_id != '#{Account::Vendors::RedHat}'"      +
                       " AND owner_id != '#{Account::Vendors::RightScale}'"  +
                       " AND owner_id != '#{Account::Vendors::Scalr}'")
  end
end
