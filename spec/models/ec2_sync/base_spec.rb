require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe EC2Sync::Base do
  before do
    @ec2sync_base = EC2Sync::Base.new(mock('account'))
  end

  describe "sync" do
    before do
      @ec2sync_base.stub!(:create_and_update_listed)
      @ec2sync_base.stub!(:update_or_remove_missing)
    end

    it "should create and update listed" do
      @ec2sync_base.should_receive(:create_and_update_listed)
    end

    it "should update or remove missing" do
      @ec2sync_base.should_receive(:update_or_remove_missing)
    end

    after do
      @ec2sync_base.sync!
    end
  end

  describe "remotes" do
    before do
      @ec2sync_base.stub!(:get_remotes).and_return([])
    end

    it "should only call get_remotes once and memoize result" do
      @ec2sync_base.should_receive(:get_remotes).once.and_return([])
      @ec2sync_base.remotes
      @ec2sync_base.remotes # called twice to test 'get_remotes' only gets called once
    end

    it "should set @remotes" do
      @ec2sync_base.instance_variable_get('@remotes').should == nil
      @ec2sync_base.remotes
      @ec2sync_base.instance_variable_get('@remotes').should == []
    end
  end

  describe "locals" do
    before do
      @ec2sync_base.stub!(:get_locals).and_return([])
    end

    it "should only call get_locals once and memoize result" do
      @ec2sync_base.should_receive(:get_locals).once.and_return([])
      @ec2sync_base.locals
      @ec2sync_base.locals # called twice to test 'get_locals' only gets called once
    end

    it "should set @locals" do
      @ec2sync_base.instance_variable_get('@locals').should == nil
      @ec2sync_base.locals
      @ec2sync_base.instance_variable_get('@locals').should == []
    end
  end


  describe "create and update listed" do
    before do
      @old_local = mock("old_local", :name => "foo", :save => true)
      @new_local = mock("new_local", :save => true)

      @ec2sync_base.stub!(:remotes).and_return([mock("item", :name => "foo"), mock("item", :name => "bar")]) # remote: 2 records
      @ec2sync_base.stub!(:locals).and_return([@old_local])                                                  # local:  1 record
      @ec2sync_base.stub!(:new_local).once.and_return(@new_local)
      @ec2sync_base.stub!(:update_from_remote)

      # define a simple is_equal? method for testing
      def @ec2sync_base.is_equal?(local, remote)
        local.name == remote.name
      end
    end

    it "should create a new item if remote object doesn't exist locally" do
      @ec2sync_base.should_receive(:new_local).once.and_return(@new_local)
    end

    it "should update new or existing local records with remote data" do
      @ec2sync_base.should_receive(:update_from_remote).twice
    end

    it "should save locals" do
      @old_local.should_receive(:save)
      @new_local.should_receive(:save)
    end

    after do
      @ec2sync_base.create_and_update_listed
    end
  end

  describe "update or remove missing" do
    it "should pass any missing local records to the 'handle_missing' method - defined on sub-classes" do
      old_local = mock("old_local")
      @ec2sync_base.stub!(:remotes).and_return([])         # remote: 0 records
      @ec2sync_base.stub!(:locals).and_return([old_local]) # local:  1 record

      @ec2sync_base.should_receive(:handle_missing).with(old_local)

      @ec2sync_base.update_or_remove_missing
    end
  end
end