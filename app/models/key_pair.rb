class KeyPair < ActiveRecord::Base
  belongs_to :account

  attr_accessible :aws_key_name
end
