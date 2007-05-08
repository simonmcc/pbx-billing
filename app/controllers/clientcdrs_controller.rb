require 'faster_csv'

class ClientcdrsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@clientcdr_pages, @clientcdrs = paginate :clientcdrs, :per_page => 30


    #  @clientcdr_pages = Paginator.new self, Clientcdr.count, 30, @params['page']
    #  @clientcdrs = Clientcdr.find_all nil, 'clientbill_id, dt',
    #          @clientcdr_pages.current.to_sql

    if params[:clientbill_id]
      @clientbill_id = params[:clientbill_id]
      sql = "select id, clientbill_id, src, dst, dt, cost from clientcdrs where clientbill_id = "+@clientbill_id.to_s

      @clientcdr_pages, @clientcdrs = paginate_by_sql Clientcdr, sql, 30

    else
      @clientcdr_pages, @clientcdrs = paginate :clientcdrs, :per_page => 30
    end

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

  def export_to_excel
    e = Excel::Workbook.new

    if params[:clientbill_id]
      @clientbillcdrs = Clientcdr.find(:all, 
				:conditions => ["clientbill_id = ?", params[:clientbill_id]])
    else
      @clientbillcdrs = Clientcdr.find(:all)
    end

    e.addWorksheetFromActiveRecord "ClientBill", "clientcdr", @clientbillcdrs
    headers['Content-Type'] = "application/vnd.ms-excel"
    render_text(e.build)
  end


  def export_to_csv

    if params[:clientbill_id]
      @clientbillcdrs = Clientcdr.find(:all, 
				:conditions => ["clientbill_id = ?", params[:clientbill_id]])
    else
      @clientbillcdrs = Clientcdr.find(:all)
    end

    stream_csv do|csv|
      csv << ["Source", "Destination", "Date", "Cost" ]

      @clientbillcdrs.each do |record|
        csv << [record['src'],
                record['dst'],
                record['dt'],
                record['cost']]
      end
    end
  end

  private
    def stream_csv
       filename = params[:action] + ".csv"    

       #this is required if you want this to work with IE        
       if request.env['HTTP_USER_AGENT'] =~ /msie/i
         headers['Pragma'] = 'public'
         headers["Content-type"] = "text/plain" 
         headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
         headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
         headers['Expires'] = "0" 
       else
         headers["Content-Type"] ||= 'text/csv'
         headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
       end

      render :text => Proc.new { |response, output|
        csv = FasterCSV.new(output, :row_sep => "\r\n") 
        yield csv
      }
    end


end
