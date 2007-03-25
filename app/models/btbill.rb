require "faster_csv"

class Btbill < ActiveRecord::Base

    has_many :Btbilldetail, :dependent => :delete_all

    def self.upload_csv(btbill_id, csvstring)

	calledno = String.new

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

	    Btbilldetail.create(row.to_hash)
        end
    end

end
