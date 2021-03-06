class InstancesController < ApplicationController
  before_filter :login_required
  before_filter :find_instance, :only => [:show, :edit, :update, :destroy]

  # GET /instances
  # GET /instances.xml
  def index
    @instances = current_account.instances.all(:order => "aws_image_id asc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instance }
    end
  end

  # GET /instances/new
  # GET /instances/new.xml
  def new
    @instance = current_account.instances.new

    @account_machines   = current_account.images.machines.available.for_select
    @all_machines       = Image.machines.available.are_public.for_select
    @kernels            = Image.kernels.available.are_public.for_select
    @ramdisks           = Image.ramdisks.available.are_public.for_select
    @availability_zones = current_account.availability_zones.available.for_select
    @security_groups    = current_account.security_groups.for_select
    @key_pairs          = current_account.key_pairs.for_select

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instance }
    end
  end

  # GET /instances/1/edit
  def edit
  end

  # POST /instances
  # POST /instances.xml
  def create
    @instance = current_account.instances.new(params[:instance])

    respond_to do |format|
      if @instance.save
        flash[:notice] = 'Instance was successfully created.'
        format.html { redirect_to(@instance) }
        format.xml  { render :xml => @instance, :status => :created, :location => @instance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.xml
  def update
    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        flash[:notice] = 'Instance was successfully updated.'
        format.html { redirect_to(@instance) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.xml
  def destroy
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to(instances_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def find_instance
      @instance = current_account.instances.find(params[:id])
    end
end
