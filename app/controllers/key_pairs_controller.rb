class KeyPairsController < ApplicationController
  before_filter :login_required
  before_filter :find_keypair, :only => [:show, :destroy]

  # GET /key_pairs
  # GET /key_pairs.xml
  def index
    @key_pairs = current_account.key_pairs.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @key_pairs }
    end
  end

  # POST /key_pairs/sync
  def sync
    current_account.sync_key_pairs_with_ec2
    redirect_to key_pairs_path
  end

  # GET /key_pairs/1
  # GET /key_pairs/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @key_pair }
    end
  end

  # GET /key_pairs/new
  # GET /key_pairs/new.xml
  def new
    @key_pair = current_account.key_pairs.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @key_pair }
    end
  end

  # POST /key_pairs
  # POST /key_pairs.xml
  def create
    @key_pair = current_account.key_pairs.new(params[:key_pair])

    respond_to do |format|
      if @key_pair.save
        flash[:notice] = 'KeyPair was successfully created.'
        format.html { redirect_to(@key_pair) }
        format.xml  { render :xml => @key_pair, :status => :created, :location => @key_pair }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @key_pair.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /key_pairs/1
  # DELETE /key_pairs/1.xml
  def destroy
    @key_pair.destroy

    respond_to do |format|
      format.html { redirect_to(key_pairs_url) }
      format.xml  { head :ok }
    end
  end

  private
    def find_keypair
      @key_pair = current_account.key_pairs.find(params[:id])
    end
end
