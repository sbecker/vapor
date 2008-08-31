class SecurityGroupsController < ApplicationController
  before_filter :login_required
  before_filter :find_security_group, :only => [:show, :edit, :update, :destroy]

  # GET /security_groups
  # GET /security_groups.xml
  def index
    @security_groups = current_account.security_groups.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @security_groups }
    end
  end

  # GET /security_groups/1
  # GET /security_groups/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @security_group }
    end
  end

  # GET /security_groups/new
  # GET /security_groups/new.xml
  def new
    @security_group = current_account.security_groups.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @security_group }
    end
  end

  # GET /security_groups/1/edit
  def edit
  end

  # POST /security_groups
  # POST /security_groups.xml
  def create
    @security_group = current_account.security_groups.new(params[:security_group])

    respond_to do |format|
      if @security_group.save
        flash[:notice] = 'SecurityGroup was successfully created.'
        format.html { redirect_to(@security_group) }
        format.xml  { render :xml => @security_group, :status => :created, :location => @security_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @security_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /security_groups/1
  # PUT /security_groups/1.xml
  def update
    respond_to do |format|
      if @security_group.update_attributes(params[:security_group])
        flash[:notice] = 'SecurityGroup was successfully updated.'
        format.html { redirect_to(@security_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @security_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /security_groups/1
  # DELETE /security_groups/1.xml
  def destroy
    @security_group.destroy

    respond_to do |format|
      format.html { redirect_to(security_groups_path) }
      format.xml  { head :ok }
    end
  end

  private
    def find_security_group
      @security_group = current_account.security_groups.find(params[:id])
    end
end
