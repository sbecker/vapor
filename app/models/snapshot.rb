class Snapshot < ActiveRecord::Base
  belongs_to :account

  attr_accessible :aws_volume_id
end
