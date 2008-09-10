class AccountsController < ApplicationController
  before_filter :login_required
  before_filter :find_account, :only => [:show, :edit, :update, :destroy, :sync]

  # GET /account
  # GET /account.xml
  def show
    unless @account
      redirect_to new_account_path
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /account/new
  # GET /account/new.xml
  def new
    @account = current_user.build_account

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /account/edit
  def edit
  end

  # POST /account
  # POST /account.xml
  def create
    @account = current_user.build_account(params[:account])

    respond_to do |format|
      if @account.save
        current_user.save # retain account id
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(account_path) }
        format.xml  { render :xml => @account, :status => :created, :location => account_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account
  # PUT /account.xml
  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(account_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account
  # DELETE /account.xml
  def destroy
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(account_path) }
      format.xml  { head :ok }
    end
  end

  # POST /account/sync
  def sync
    @account.sync_with_ec2
    redirect_to dashboard_path
  end

  protected
    def find_account
      @account = current_user.account
    end
end
