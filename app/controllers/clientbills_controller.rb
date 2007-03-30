class ClientbillsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @clients = Client.find(:all)
    @clientbill_pages, @clientbills = paginate :clientbills, :per_page => 10
  end

  def show
    @clients = Client.find(:all)
    @clientbill = Clientbill.find(params[:id])
  end

  def new
    @clients = Client.find(:all)
    if params[:client_id].nil?
      @clientbill = Clientbill.new
    else
      @clientbill = Clientbill.new( :client_id => params[:client_id])
    end
  end

  def new_with_client_id
    @clientbill = Clientbill.new( :client_id => params[:client_id])
    logger.info "Where do we go after a new? to the view?"
  end

  def create
    @clientbill = Clientbill.new(params[:clientbill])
    if @clientbill.save
      flash[:notice] = 'Clientbill was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @clients = Client.find(:all)
    @clientbill = Clientbill.find(params[:id])
  end

  def update
    @clientbill = Clientbill.find(params[:id])
    if @clientbill.update_attributes(params[:clientbill])
      flash[:notice] = 'Clientbill was successfully updated.'
      redirect_to :action => 'show', :id => @clientbill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Clientbill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def create_clientcdrs
    clientbill = Clientbill.find(params[:id])
    clientbill.create_clientcdrs(params[:id])
    redirect_to :controller => 'clientcdrs', :action => 'list'
  end

  def clear_clientcdrs
    cdrs = Clientcdr.find(:all, :conditions => ["clientbill_id = ?", params[:clientbill_id]])
    cdrs.each do |cdr|
	cdr.destroy
    end

    redirect_to :action => 'list'
  end

end
