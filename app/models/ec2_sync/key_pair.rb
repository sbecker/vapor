class EC2Sync::KeyPair
  def initialize(account)
    @account = account
  end

  def sync!
    create_and_update_listed
    delete_unlisted
  end

  def ec2_key_pairs
    @ec2_key_pairs ||= @account.ec2.describe_keypairs.keySet.item
  end

  def local_key_pairs
    @local_images ||= @account.key_pairs.all
  end

  def create_and_update_listed
    ec2_key_pairs.each do |ec2_key_pair|
      local_key_pair = local_key_pairs.detect{|i| i.name == ec2_key_pair.keyName && i.fingerprint == ec2_key_pair.keyFingerprint } || @account.key_pairs.new
      update_from_ec2(local_key_pair, ec2_key_pair)
    end
  end

  def delete_unlisted
    missing_key_pairs = local_key_pairs.reject {|i| ec2_key_pairs.detect{|e| i.aws_id == e.imageId } }
    missing_key_pairs.each do |missing_key_pair|
      missing_key_pair.destroy
    end
  end

  def update_from_ec2(local_key_pair, ec2_key_pair)
    local_key_pair.name        = ec2_key_pair.keyName
    local_key_pair.fingerprint = ec2_key_pair.keyFingerprint

    local_key_pair.save
  end
end
