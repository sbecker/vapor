class EC2Sync::Base
  def initialize(account)
    @account = account
  end

  def sync!
    create_and_update_listed
    update_or_remove_missing
  end

  def remotes
    @remotes ||= get_remotes
  end

  def locals
    @locals ||= get_locals
  end

  def create_and_update_listed
    remotes.each do |remote|
      local = locals.detect{|l| is_equal?(l, remote) } || new_local
      update_from_remote(local, remote)
      local.save
    end
  end

  def update_or_remove_missing
    missing_locals = locals.reject {|l| remotes.detect{|r| is_equal?(l, r) } }
    missing_locals.each do |missing_local|
      handle_missing(missing_local)
    end
  end

  # Template methods that must be implemented by sub-classes

  # Get an array of objects from local source
  def get_locals
    raise 'Called abstract method: get_locals'
  end

  # Get an array of objects from remote source
  def get_remotes
    raise 'Called abstract method: get_remotes'
  end

  # Get a new instance of a local model - possibly scoped to
  def new_local
    raise 'Called abstract method: new_local'
  end

  # Is local object equal to remote object
  def is_equal?(local, remote)
    raise 'Called abstract method: is_equal?(local, remote)'
  end

  # Update local object with attributes from remote object
  def update_from_remote(local, remote)
    raise 'Called abstract method: update_from_remote(local, remote)'
  end

  # Should handle what to do if item still exists locally but no longer remotely
  def handle_missing(local)
    raise 'Called abstract method: handle_missing(local)'
  end
end