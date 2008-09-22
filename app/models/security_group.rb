class SecurityGroup < ActiveRecord::Base
  belongs_to :account

  named_scope :for_select, :select => 'aws_group_name'

  serialize :aws_perms
end
