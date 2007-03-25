class PbxcdrsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pbxcdr_pages, @pbxcdrs = paginate :pbxcdrs, :per_page => 10
  end

  def show
    @pbxcdr = Pbxcdr.find(params[:id])
  end

  def new
    @pbxcdr = Pbxcdr.new
  end

  def create
    @pbxcdr = Pbxcdr.new(params[:pbxcdr])
    if @pbxcdr.save
      flash[:notice] = 'Pbxcdr was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pbxcdr = Pbxcdr.find(params[:id])
  end

  def update
    @pbxcdr = Pbxcdr.find(params[:id])
    if @pbxcdr.update_attributes(params[:pbxcdr])
      flash[:notice] = 'Pbxcdr was successfully updated.'
      redirect_to :action => 'show', :id => @pbxcdr
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pbxcdr.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
