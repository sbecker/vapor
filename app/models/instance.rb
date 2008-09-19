class Instance < ActiveRecord::Base
  belongs_to :account

  serialize :aws_product_codes
  serialize :aws_groups
end
