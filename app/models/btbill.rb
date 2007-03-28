require "faster_csv"

class Btbill < ActiveRecord::Base

    has_many :Btbilldetail, :dependent => :delete_all

    def self.upload_csv(btbill_id, csvstring)

	calledno = String.new
	dt = String.new
        a = Array.new
       

        # Parse the CSV
	FasterCSV.parse(csvstring.read, :headers => true, :header_converters => [:downcase]) do |row|

	    # use row here...
	    # Create a btbilldetails object, using the row, which we have inserted
   	    # the btbill id record into

    	    row << ({ 'btbill_id' => btbill_id })

  	    # Get the calledno field, remove the space & add it back to the row
	    calledno = row.field('calledno').gsub(/ /, '')
	    row.delete('calledno')
    	    row << ({ 'calledno' => calledno })

  	    # Create a datetime field from the date & time fields
	    # BT Date field is DD/MM/YYYY, db wants YYYY-MM-DD
	    a = row.field('date').split(/\//)
	    dt = a[2] + "-" + a[1] + "-" + a[0] + " " + row.field('time')
	    #dt = row.field('date') + " " + row.field('time')
	    row.delete('date')
	    row.delete('time')
    	    row << ({ 'dt' => dt })

	    # Create an integer from the HH:MM::SS duration field
	    a = row.field('duration').split(/:/)
	    dur = (a[0].to_i * 60 * 60) + (a[1].to_i*60) + a[2].to_i
	    row.delete('duration')
    	    row << ({ 'duration' => dur })
	    
	
	    #logger.info row

	    Btbilldetail.create(row.to_hash)
        end
    end
end
