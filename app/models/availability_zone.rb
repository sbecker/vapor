class AvailabilityZone < ActiveRecord::Base
  belongs_to :account

  named_scope :available,  :conditions => {:zone_state => 'available'}
  named_scope :for_select, :select     => 'zone_name'
end
