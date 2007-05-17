
class Clientbill < ActiveRecord::Base
    belongs_to :Client
    has_many :Clientcdr, :dependent => :delete_all

  def create_clientcdrs(clientbill_id)
    # Using the startdate & enddate from this object,
    # populate a set of clientcdr objects

    tmpnum = String.new
    #
    # pbxcdrs.start/answer should match btbilldetails.date/time
    # pbxcdrs.dst should match btbilldetails.calledno (calledno may have spaces)
    # pbxcdrs.duration/billsec should be _close_ to btbilldetails.duration
    # btbilldetaila.cost is what we are looking for
   
    @client = Client.find(client_id)
    logger.debug @client.startext
    logger.debug @client.endext
    logger.debug clientbill_id

    #
    # First, find all the pbxcdr objects in our date range, and in our extension range
    @pbxcdrs = Pbxcdr.find(:all, 
	:conditions => [ "answer >= ? and answer <= ? and src >= ? and src <= ? and billsec >0 and dstchannel like ?", 
				startdate, enddate, @client.startext, @client.endext, "Zap%"]) 

    #
    # Now cycle through each record and try and find the match in the btbilldetail objects
    @pbxcdrs.each do |pbxcdr|
        logger.debug pbxcdr.answer
 	logger.debug pbxcdr.dst

	# The BT Bill only has HH:MM, no seconds, so we could be out by a minute either way.
	# (we should maybe just trim the seconds from the pbxcdr, but I don't know how to do that!
	ansmin = Time.parse(pbxcdr.answer.to_s) - 60;
	ansmax = Time.parse(pbxcdr.answer.to_s) + 60; 
 
	billsecmin = pbxcdr.billsec - 1;
	billsecmax = pbxcdr.billsec + 1;

 	logger.debug ansmin
 	logger.debug ansmax
	
	#
	# Find the btbilldetail object that matches this
	# add the leading 0
	tmpnum = "0" + pbxcdr.dst
	@btcdr = Btbilldetail.find(:first, 
			:conditions => [ "(calledno = ? OR calledno = ?) and dt >= ? and dt <= ? and duration >= ? AND duration <= ?", 
					pbxcdr.dst, tmpnum, ansmin, ansmax, billsecmin, billsecmax ])
	if @btcdr.nil?
	  logger.debug "1:Couldn't find btbilldetail to match this!!"
	  @btcdr = Btbilldetail.find(:first, :conditions => 
		[ "calledno = ? and dt >= ? and dt <= ? and duration >= ? AND duration <= ?", 
					pbxcdr.dst, ansmin, ansmax, billsecmin, billsecmax ])
	  if @btcdr.nil?
	    logger.debug "2:Couldn't find btbilldetail to match this!!"
            if /^141/ =~ pbxcdr.dst
	      logger.debug "Trying with leading 141 removed"
  	      fixed_dst = pbxcdr.dst.sub(/^141/, "")
	      @btcdr = Btbilldetail.find(:first, :conditions => 
		    [ "calledno = ? and dt >= ? and dt <= ? and duration >= ? AND duration <= ?", 
					    fixed_dst, ansmin, ansmax, billsecmin, billsecmax ])
            end
          end

	  if @btcdr.nil?
	    logger.debug "3:Couldn't find btbilldetail to match this!!"
	    logger.debug "Trying to find just using time/duration.."
	     @btcdr = Btbilldetail.find(:first, :conditions => 
		    [ "dt >= ? and dt <= ? and duration >= ? AND duration <= ?", 
					     ansmin, ansmax, billsecmin, billsecmax ])
          end
	end

	logger.debug @btcdr.calledno
	logger.debug @btcdr.dt
	logger.debug @btcdr.cost

	#
	# Create the clientcdr object from what we have found.
	clientcdr = Clientcdr.new do |cdr|
	  cdr.clientbill_id = clientbill_id
	  cdr.src = pbxcdr.src
	  cdr.dst = pbxcdr.dst
	  cdr.dt  = pbxcdr.answer

	  if not @btcdr.nil?
	    cdr.cost = @btcdr.cost
	  end
	end
	clientcdr.save

    end # pbxcdrs.each do...
  end # method

end
