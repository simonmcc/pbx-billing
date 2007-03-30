class ClientcdrsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @clientcdr_pages, @clientcdrs = paginate :clientcdrs, :per_page => 30
  end

  def show
    @clientcdr = Clientcdr.find(params[:id])
  end

  def new
    @clientcdr = Clientcdr.new
  end

  def create
    @clientcdr = Clientcdr.new(params[:clientcdr])
    if @clientcdr.save
      flash[:notice] = 'Clientcdr was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @clientcdr = Clientcdr.find(params[:id])
  end

  def update
    @clientcdr = Clientcdr.find(params[:id])
    if @clientcdr.update_attributes(params[:clientcdr])
      flash[:notice] = 'Clientcdr was successfully updated.'
      redirect_to :action => 'show', :id => @clientcdr
    else
      render :action => 'edit'
    end
  end

  def destroy
    Clientcdr.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
