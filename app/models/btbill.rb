require "faster_csv"

class Btbill < ActiveRecord::Base

    has_many :Btbilldetail, :dependent => :delete_all

    def self.upload_csv(btbill_id, csvstring)

        # Parse the CSV
	FasterCSV.parse(csvstring.read, :headers => true, :header_converters => [:downcase]) do |row|

	    # use row here...
	    # Create a btbilldetails object, using the row, which we have inserted
   	    # the btbill id record into

    	    row << ({ 'btbill_id' => btbill_id })

	    Btbilldetail.create(row.to_hash)
        end
    end

end
