class VolumesController < ApplicationController
  before_filter :login_required
  before_filter :find_volume, :only => [:show, :edit, :update, :destroy]

  # GET /volumes
  # GET /volumes.xml
  def index
    @volumes = current_account.volumes.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @volumes }
    end
  end

  # GET /volumes/1
  # GET /volumes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @volume }
    end
  end

  # GET /volumes/new
  # GET /volumes/new.xml
  def new
    @volume = current_account.volumes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @volume }
    end
  end

  # GET /volumes/1/edit
  def edit
  end

  # POST /volumes
  # POST /volumes.xml
  def create
    @volume = current_account.volumes.new(params[:volume])

    respond_to do |format|
      if @volume.save
        flash[:notice] = 'Volume was successfully created.'
        format.html { redirect_to(@volume) }
        format.xml  { render :xml => @volume, :status => :created, :location => @volume }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @volume.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /volumes/1
  # PUT /volumes/1.xml
  def update
    respond_to do |format|
      if @volume.update_attributes(params[:volume])
        flash[:notice] = 'Volume was successfully updated.'
        format.html { redirect_to(@volume) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @volume.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /volumes/1
  # DELETE /volumes/1.xml
  def destroy
    @volume.destroy

    respond_to do |format|
      format.html { redirect_to(volumes_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def find_volume
      @volume = current_account.volumes.find(params[:id])
    end
end
