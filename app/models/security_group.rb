class SecurityGroup < ActiveRecord::Base
  belongs_to :account

  serialize :aws_perms
end
