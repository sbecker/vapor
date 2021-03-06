class Image < ActiveRecord::Base
  belongs_to :account

  # would just use "public" but this causes weird nil.call errors in rspec - SMB 8/22/08
  # see http://www.nabble.com/Mysterious-interaction-between-RSpec-1.1.4-and-has_finder-named_scope-tt17810058.html#a17810058
  named_scope :are_public, :order => 'aws_location', :conditions => {:aws_is_public  => true}
  named_scope :not_public, :order => 'aws_location', :conditions => {:aws_is_public  => false}
  named_scope :available,  :order => 'aws_location', :conditions => {:aws_state      => 'available'}
  named_scope :machines,   :order => 'aws_location', :conditions => {:aws_image_type => 'machine'}
  named_scope :kernels,    :order => 'aws_location', :conditions => {:aws_image_type => 'kernel'}
  named_scope :ramdisks,   :order => 'aws_location', :conditions => {:aws_image_type => 'ramdisk'}
  named_scope :for_select, :select => 'aws_id, aws_location'
  named_scope :allowed_for, lambda { |account| { :conditions => ["aws_is_public = ? OR account_id = ?", true, account.id] }}

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

  # Associates the image with an account if an account exists for that owner
  # using Account#ids_from_account_numbers which returns a hash
  # with account numbers as keys and account ids as values
  def aws_owner=(val)
    self.account_id = Account.ids_from_account_numbers[val]
    write_attribute :aws_owner, val
  end

  def aws_location_short
    aws_location.gsub(/.manifest.xml/, '').titleize
  end
end
