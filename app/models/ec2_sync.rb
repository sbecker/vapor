class EC2Sync
  def self.refresh_lookup_hashes
    Account.ids_from_account_numbers(true) # used in images sync
  end

  def self.sync_account(account)
    refresh_lookup_hashes

    {
      :address           => :public_ip,
      :availability_zone => :zone_name,
      :image             => :aws_id,
      :instance          => :aws_instance_id,
      :key_pair          => :aws_key_name,
      :security_group    => :aws_group_name,
      ###:snapshot          => :aws_id,
      :volume            => :aws_id
    }.each_pair do |model_name, unique_attribute|
      new(account, model_name, unique_attribute).sync!
    end
  end

  def initialize(account, model_name, unique_attribute)
    @account          = account
    @model_name       = model_name.to_s.pluralize
    @unique_attribute = unique_attribute
  end

  def sync!
    create_and_update_listed
    update_or_remove_missing
  end

  def create_and_update_listed
    remotes.each do |remote|
      local = locals.detect{|l| is_equal?(l, remote) } || new_local
      local.send :attributes=, remote, false
      local.save
    end
  end

  def update_or_remove_missing
    missing_locals = locals.reject {|l| remotes.detect{|r| is_equal?(l, r) } }
    missing_locals.each do |missing_local|
      handle_missing(missing_local)
    end
  end

  # Cache results of get_remotes
  def remotes
    @remotes ||= get_remotes
  end

  # Get an array of objects from remote source
  def get_remotes
    @account.ec2.send("describe_#{@model_name}")
  end

  # Cache results of get_locals
  def locals
    @locals ||= get_locals
  end

  # Get an array of objects from local source
  def get_locals
    if(@model_name == 'images')
      ::Image.available.all(:conditions => ["aws_is_public = ? OR account_id = ?", true, @account.id])
    else
      @account.send(@model_name)
    end
  end

  # Get a new instance of a local model
  def new_local
    if(@model_name == 'images')
      ::Image.new
    else
      locals.new
    end
  end

  # Is local object equal to remote object
  def is_equal?(local, remote)
    local.read_attribute(@unique_attribute) == remote[@unique_attribute]
  end

  # Should handle what to do if item still exists locally but no longer remotely
  def handle_missing(local)
    if(@model_name == 'images')
      local.update_attribute(:aws_state, "deregistered")
    else
      local.destroy
    end
  end
end