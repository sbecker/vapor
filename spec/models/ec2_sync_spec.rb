require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EC2Sync do
  describe "syncing an account" do
    before do
      @account = mock('account')
      @mock_sync = mock('EC2Sync', :sync! => true)
      EC2Sync.stub!(:new).and_return(@mock_sync)
    end

    it "should refresh the lookup hashes" do
      EC2Sync.should_receive(:refresh_lookup_hashes)
    end

    it "should sync all ec2 resources for account" do
      EC2Sync.should_receive(:new).with(@account, :address, :public_ip).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :availability_zone, :zone_name).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :image, :aws_id).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :instance, :aws_instance_id).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :key_pair, :aws_key_name).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :security_group, :aws_group_name).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :snapshot, :aws_id).and_return(@mock_sync)
      EC2Sync.should_receive(:new).with(@account, :volume, :aws_id).and_return(@mock_sync)
    end

    after do
      EC2Sync.sync_account(@account)
    end
  end

  describe "refreshing lookup hashes" do
    it "should refresh the account ids from account numbers hash" do
      Account.should_receive(:ids_from_account_numbers).with(true)
      EC2Sync.refresh_lookup_hashes
    end
  end

  describe "instance methods" do
    before do
      stub_account_with_ec2
      @ec2sync = EC2Sync.new(@account, :resource, :name)
    end

    describe "sync!" do
      before do
        @ec2sync.stub!(:create_and_update_listed)
        @ec2sync.stub!(:update_or_remove_missing)
      end

      it "should create and update listed" do
        @ec2sync.should_receive(:create_and_update_listed)
      end

      it "should update or remove missing" do
        @ec2sync.should_receive(:update_or_remove_missing)
      end

      after do
        @ec2sync.sync!
      end
    end

    describe "remotes" do
      before do
        @ec2sync.stub!(:get_remotes).and_return([])
      end

      it "should only call get_remotes once and memoize result" do
        @ec2sync.should_receive(:get_remotes).once.and_return([])
        @ec2sync.remotes
        @ec2sync.remotes # called twice to prove 'get_remotes' only gets called once the first time
      end

      it "should set @remotes" do
        @ec2sync.instance_variable_get('@remotes').should == nil
        @ec2sync.remotes
        @ec2sync.instance_variable_get('@remotes').should == []
      end
    end

    describe "get remotes" do
      it "should call describe_<plural_model_name> on the account's ec2 object" do
        @ec2.should_receive(:describe_resources).and_return([])
        @ec2sync.get_remotes
      end
    end

    describe "locals" do
      before do
        @ec2sync.stub!(:get_locals).and_return([])
      end

      it "should only call get_locals once and memoize result" do
        @ec2sync.should_receive(:get_locals).once.and_return([])
        @ec2sync.locals
        @ec2sync.locals # called twice to test 'get_locals' only gets called once
      end

      it "should set @locals" do
        @ec2sync.instance_variable_get('@locals').should == nil
        @ec2sync.locals
        @ec2sync.instance_variable_get('@locals').should == []
      end
    end

    describe "get locals" do
      it "should get the accounts associated objects via the model name" do
        resources = mock('resources')
        @account.should_receive(:send).with('resources').and_return(resources)
        @ec2sync.get_locals
      end
    end

    describe "get locals for images" do
      it "should get a list of all 'available' images currently in the DB that are either public or belong to this account" do
        @ec2sync = EC2Sync.new(@account, :image, :aws_id)

        available = mock("available")
        Image.stub!(:available).and_return(available)
        available.should_receive(:all).with(:conditions => ["aws_is_public = ? OR account_id = ?", true, @account.id]).and_return([])
        @ec2sync.get_locals
      end
    end

    describe "new local" do
      it "should return a new instance of the local model class" do
        locals = mock('locals')
        locals.should_receive(:new)
        @ec2sync.should_receive(:locals).and_return(locals)
        @ec2sync.new_local
      end
    end

    describe "new local for images" do
      it "should return a new instance of the local model class" do
        @ec2sync = EC2Sync.new(@account, :image, :aws_id)
        ::Image.should_receive(:new)
        @ec2sync.new_local
      end
    end

    describe "create and update listed" do
      before do
        @old_local = mock("old_local", :name => "foo", :read_attribute => "foo", :save => true, :attributes= => true)
        @new_local = mock("new_local", :save => true, :attributes= => true)

        @old_remote = {:name => "foo"}
        @new_remote = {:name => "bar"}

        @ec2sync.stub!(:remotes).and_return([@old_remote, @new_remote]) # remote: 2 records
        @ec2sync.stub!(:locals).and_return([@old_local])                # local:  1 record
        @ec2sync.stub!(:new_local).once.and_return(@new_local)
        @ec2sync.stub!(:update_from_remote)
      end

      it "should create a new item if remote object doesn't exist locally" do
        @ec2sync.should_receive(:new_local).once.and_return(@new_local)
      end

      it "should update new or existing local records with remote data" do
        @old_local.should_receive(:attributes=).with(@old_remote, false)
        @new_local.should_receive(:attributes=).with(@new_remote, false)
      end

      it "should save locals" do
        @old_local.should_receive(:save)
        @new_local.should_receive(:save)
      end

      after do
        @ec2sync.create_and_update_listed
      end
    end

    describe "update or remove missing" do
      it "should pass any missing local records to the 'handle_missing' method" do
        old_local = mock("old_local")
        @ec2sync.stub!(:remotes).and_return([])         # remote: 0 records
        @ec2sync.stub!(:locals).and_return([old_local]) # local:  1 record

        @ec2sync.should_receive(:handle_missing).with(old_local)

        @ec2sync.update_or_remove_missing
      end
    end

    describe "is equal" do
      it "should be true if local unique attribute equals the remote unique attribute" do
        @ec2sync.is_equal?(mock('local', :read_attribute => 'foo'), {:name => 'foo'}).should be_true
      end

      it "should be false if local unique attribute does not equal the remote unique attribute" do
        @ec2sync.is_equal?(mock('local', :read_attribute => 'foo'), {:name => 'bar'}).should be_false
      end
    end

    describe "handle missing" do
      it "should call destroy on the item" do
        @item = mock('item')
        @item.should_receive(:destroy)
        @ec2sync.handle_missing(@item)
      end
    end

    describe "handle missing for images" do
      it "should set the state to 'deregistered'" do
        @ec2sync = EC2Sync.new(@account, :image, :aws_id)

        @image = mock('image')
        @image.should_receive(:update_attribute).with(:aws_state, "deregistered")
        @ec2sync.handle_missing(@image)
      end
    end
  end
end