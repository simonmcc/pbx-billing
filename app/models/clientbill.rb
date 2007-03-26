class Clientbill < ActiveRecord::Base
    belongs_to :Client
    has_many :Clientcdr, :dependent => :delete_all

  def create_clientcdrs
    # Using the startdate & enddate from this object,
    # populate a set of clientcdr objects

    #
    # pbxcdrs.start/answer should match btbilldetails.date/time
    # pbxcdrs.dst should match btbilldetails.calledno (calledno may have spaces)
    # pbxcdrs.duration/billsec should be _close_ to btbilldetails.duration
    # btbilldetaila.cost is what we are looking for
   
    @client = Client.find(client_id)
    logger.debug @client.extensions

    #
    # First, find all the pbxcdr objects in our date range, and in our extension range
    @pbxcdrs = Pbxcdr.find(:all, 
			:conditions => [ "answer >= ? and answer <= ? and src = ? and billsec >0", 
							startdate, enddate, @client.extensions]) 

    #
    # Now cycle through each record and try and find the match in the btbilldetail objects
    @pbxcdrs.each do |pbxcdr|
        logger.debug pbxcdr.answer
 	logger.debug pbxcdr.dst
	
	#
	# Find the btbilldetail object that matches this
	@btcdr = Btbilldetail.find(:first, :conditions => [ "calledno = ? and date = ? ", 
								pbxcdr.dst, pbxcdr.answer ])
	if @btcdr.nil?
	  logger.debug "Nil!!"
	  # Try dropping the leading 0?
	  tmpnum = String.new(pbxcdr.dst)
	  tmpnum.sub('0', '')
	  @btcdr = Btbilldetail.find(:first, :conditions => [ "calledno = ?", tmpnum ])
	end

	if not @btcdr.nil?
	  logger.debug @btcdr.date
	  logger.debug @btcdr.time
	  logger.debug @btcdr.cost
	end

        #
        # Create the clientcdr object from what we have found.
	clientcdr = Clientcdr.new do |cdr|
	  cdr.clientbill_id = :id
	  cdr.src = pbxcdr.src
	  cdr.dst = pbxcdr.dst
	  cdr.dt  = pbxcdr.answer

	  if not @btcdr.nil?
	    cdr.cost = @btcdr.cost
	  end
	end
	clientcdr.save
    end

  end
end
