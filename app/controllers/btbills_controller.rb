class BtbillsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @btbill_pages, @btbills = paginate :btbills, :per_page => 10

    # This is mad...
    # @btbilldetails = Btbilldetail.find(:all)
  end

  def show
    @btbill = Btbill.find(params[:id])
  end

  def new
    @btbill = Btbill.new
  end

  def create

    #
    # Save to DB

    logger.debug params['btbill']["billcsv"]

    csv = params['btbill']["billcsv"]
    # Now remove the String containing the CSV from the hash
    params['btbill'].delete('billcsv')

    # Standard save parameters that match fileds out to the database
    @btbill = Btbill.new(params[:btbill])
    if @btbill.save
      flash[:notice] = 'Btbill was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end


    # Now that the btbill object has been created, add all the children records
    # with the parent ID.

    # One of the fields is special, it should be an IOString object
    # of the file, pass this model for handling..
    # the filename might be params["billcsv"] or params["btbill"]["billcsv"]
    Btbill.upload_csv(@btbill['id'], csv)

    # 
    # Can we try and count the number of relates Btbilldetail records?
    #@btbilldetails = Btbilldetail.find(:all, :conditions => ["btbill_id = ?", @btbill['id']])

    #Btbilldetails.count_by_sql "SELECT COUNT(*) FROM btbilldetails where btbill_id=" + @btbill['id']

    @btbill 

  end

  def edit
    @btbill = Btbill.find(params[:id])
  end

  def update
    @btbill = Btbill.find(params[:id])
    if @btbill.update_attributes(params[:btbill])
      flash[:notice] = 'Btbill was successfully updated.'
      redirect_to :action => 'show', :id => @btbill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Btbill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
