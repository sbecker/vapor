class Volume < ActiveRecord::Base
  belongs_to :account

  attr_accessible :aws_device,
                  :aws_instance_id,
                  :aws_size,
                  :snapshot_id,
                  :zone
end
