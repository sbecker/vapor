class KeyPairsController < ApplicationController
  before_filter :login_required

  # GET /key_pairs
  # GET /key_pairs.xml
  def index
    @key_pairs = KeyPair.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @key_pairs }
    end
  end

  # GET /key_pairs/1
  # GET /key_pairs/1.xml
  def show
    @key_pair = KeyPair.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @key_pair }
    end
  end

  # GET /key_pairs/new
  # GET /key_pairs/new.xml
  def new
    @key_pair = KeyPair.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @key_pair }
    end
  end

  # POST /key_pairs
  # POST /key_pairs.xml
  def create
    @key_pair = KeyPair.new(params[:key_pair])

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
    @key_pair = KeyPair.find(params[:id])
    @key_pair.destroy

    respond_to do |format|
      format.html { redirect_to(key_pairs_url) }
      format.xml  { head :ok }
    end
  end
end
