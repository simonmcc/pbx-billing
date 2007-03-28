
class Clientbill < ActiveRecord::Base
    belongs_to :Client
    has_many :Clientcdr, :dependent => :delete_all

  def create_clientcdrs
    # Using the startdate & enddate from this object,
    # populate a set of clientcdr objects

    tmpnum = String.new
    ansmin = Time.new;
    andmax = Time.new;
    #
    # pbxcdrs.start/answer should match btbilldetails.date/time
    # pbxcdrs.dst should match btbilldetails.calledno (calledno may have spaces)
    # pbxcdrs.duration/billsec should be _close_ to btbilldetails.duration
    # btbilldetaila.cost is what we are looking for
   
    @client = Client.find(client_id)
    logger.debug @client.startext
    logger.debug @client.endext

    #
    # First, find all the pbxcdr objects in our date range, and in our extension range
    @pbxcdrs = Pbxcdr.find(:all, 
	:conditions => [ "answer >= ? and answer <= ? and src >= ? and src <= ? and billsec >0", 
				startdate, enddate, @client.startext, @client.endext]) 

    #
    # Now cycle through each record and try and find the match in the btbilldetail objects
    @pbxcdrs.each do |pbxcdr|
        logger.debug pbxcdr.answer
 	logger.debug pbxcdr.dst

	ansmin = Time::parse(pbxcdr.answer.to_s)
	#ansmin = Time.parse(pbxcdr.answer) - 30; 
	#ansmax = Time.parse(pbxcdr.answer) + 30; 
	
	#
	# Find the btbilldetail object that matches this
	# add the leading 0
	tmpnum = "0" + pbxcdr.dst
	@btcdr = Btbilldetail.find(:first, :conditions => [ "calledno = ? and dt >= ? and dt <= ?", 
								tmpnum, ansmin, ansmax ])
	if @btcdr.nil?
	  logger.debug "Nil!!"
	end

	if not @btcdr.nil?
	  logger.debug @btcdr.calledno
	  logger.debug @btcdr.dt
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
