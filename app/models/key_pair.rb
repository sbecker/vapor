class KeyPair < ActiveRecord::Base
  belongs_to :account

  attr_accessible :name
end
