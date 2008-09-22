class KeyPair < ActiveRecord::Base
  belongs_to :account

  named_scope :for_select, :select => 'aws_key_name'

  attr_accessible :aws_key_name
end
