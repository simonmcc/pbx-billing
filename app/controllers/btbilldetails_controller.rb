class BtbilldetailsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if params[:btbill_id].nil?
        @btbilldetail_pages, @btbilldetails = paginate :btbilldetails, :per_page => 33
    else
	@btbill_id = params[:btbill_id]
        @btbilldetail_pages, @btbilldetails = paginate 	:btbilldetails, 
							:conditions => ['btbill_id = ?', @btbill_id], 
							:per_page => 30
    end
  end

  def show
    @btbilldetail = Btbilldetail.find(params[:id])
  end

  def new
    @btbilldetail = Btbilldetail.new
  end

  def create
    @btbilldetail = Btbilldetail.new(params[:btbilldetail])
    if @btbilldetail.save
      flash[:notice] = 'Btbilldetail was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @btbilldetail = Btbilldetail.find(params[:id])
  end

  def update
    @btbilldetail = Btbilldetail.find(params[:id])
    if @btbilldetail.update_attributes(params[:btbilldetail])
      flash[:notice] = 'Btbilldetail was successfully updated.'
      redirect_to :action => 'show', :id => @btbilldetail
    else
      render :action => 'edit'
    end
  end

  def destroy
    Btbilldetail.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
