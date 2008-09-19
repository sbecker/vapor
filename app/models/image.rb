class Image < ActiveRecord::Base
  belongs_to :account

  # would just use "public" but this causes weird nil.call errors in rspec - SMB 8/22/08
  # see http://www.nabble.com/Mysterious-interaction-between-RSpec-1.1.4-and-has_finder-named_scope-tt17810058.html#a17810058
  named_scope :are_public, :order => 'aws_location', :conditions => {:aws_is_public => true}
  named_scope :not_public, :order => 'aws_location', :conditions => {:aws_is_public => false}
  named_scope :available,  :order => 'aws_location', :conditions => {:aws_state     => 'available'}

  attr_accessible :name, :description
  serialize :aws_product_codes

  def self.others(account_id)
    all(:conditions => "(account_id != #{account_id} OR account_id IS NULL)"  +
                       " AND aws_owner != '#{Account::Vendors::Alestic}'"     +
                       " AND aws_owner != '#{Account::Vendors::Amazon}'"      +
                       " AND aws_owner != '#{Account::Vendors::RBuilder}'"    +
                       " AND aws_owner != '#{Account::Vendors::RedHat}'"      +
                       " AND aws_owner != '#{Account::Vendors::RightScale}'"  +
                       " AND aws_owner != '#{Account::Vendors::Scalr}'")
  end

  def aws_owner=(val)
    self.account_id = Account.ids_from_account_numbers[val]
    write_attribute :aws_owner, val
  end
end
