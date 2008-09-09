class ImagesController < ApplicationController
  before_filter :login_required

  # GET /images
  # GET /images.xml
  def index
    @images = current_account.images.available
    respond_to_list
  end

  # GET /vendors
  # GET /vendors.xml
  def vendors
    @images = Image.available.are_public.all(:conditions => {:owner_id => params[:owner_id]})
    respond_to_list
  end

  # GET /others
  # GET /others.xml
  def others
    @images = Image.available.are_public.others(current_account.id)
    respond_to_list
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = current_account.images.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = current_account.images.find(params[:id])
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = current_account.images.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        flash[:notice] = 'Image was successfully updated.'
        format.html { redirect_to(@image) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
    def respond_to_list
      respond_to do |format|
        format.html { render :action => 'index' } # index.html.erb
        format.xml  { render :xml => @images }
      end
    end
end
