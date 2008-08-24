class ImagesController < ApplicationController
  before_filter :login_required

  # GET /images
  # GET /images.xml
  def index
    @images = current_user.images.all(:conditions => {:owner_id => current_user.account.aws_account_number})
    respond_to_list
  end

  # GET /others
  # GET /others.xml
  def others
    if params[:owner_id]
      @images = current_user.images.all(:conditions => {:owner_id => params[:owner_id]})
    else
      @images = current_user.images.all(:conditions => ['owner_id != ? AND owner_id != ?', current_user.account.aws_account_number, Account::Owners::Amazon])
    end
    respond_to_list
  end

  # POST /images/sync
  def sync
    current_user.account.sync_images_with_ec2
    redirect_to images_path
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = current_user.images.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = current_user.images.find(params[:id])
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = current_user.images.find(params[:id])

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
