class SecurityGroup < ActiveRecord::Base
  belongs_to :account

  serialize :permissions
end
