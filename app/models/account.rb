class Account < ActiveRecord::Base
  has_many :users
  has_many :images, :order => 'location'

  def ec2
    @ec2 ||= EC2::Base.new(:access_key_id => aws_access_key, :secret_access_key => aws_secret_access_key)
  end
end
