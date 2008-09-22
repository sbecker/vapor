class SnapshotsController < ApplicationController
  before_filter :login_required
  before_filter :find_snapshot, :only => [:show, :edit, :update, :destroy]

  # GET /snapshots
  # GET /snapshots.xml
  def index
    @snapshots = current_account.snapshots.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snapshots }
    end
  end

  # GET /snapshots/1
  # GET /snapshots/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snapshot }
    end
  end

  # GET /snapshots/new
  # GET /snapshots/new.xml
  def new
    @snapshot = current_account.snapshots.new
    @volumes  = current_account.volumes

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snapshot }
    end
  end

  # GET /snapshots/1/edit
  def edit
  end

  # POST /snapshots
  # POST /snapshots.xml
  def create
    @snapshot = current_account.snapshots.new(params[:snapshot])

    respond_to do |format|
      if @snapshot.save
        flash[:notice] = 'Snapshot was successfully created.'
        format.html { redirect_to(@snapshot) }
        format.xml  { render :xml => @snapshot, :status => :created, :location => @snapshot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snapshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /snapshots/1
  # PUT /snapshots/1.xml
  def update
    respond_to do |format|
      if @snapshot.update_attributes(params[:snapshot])
        flash[:notice] = 'Snapshot was successfully updated.'
        format.html { redirect_to(@snapshot) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snapshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /snapshots/1
  # DELETE /snapshots/1.xml
  def destroy
    @snapshot.destroy

    respond_to do |format|
      format.html { redirect_to(snapshots_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def find_snapshot
      @snapshot = current_account.snapshots.find(params[:id])
    end
end
