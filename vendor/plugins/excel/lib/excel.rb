
module Excel
    # Class designed to create a multiple-sheet workbook in Excel from ActiveRecord model objects
	class Workbook
	  
	    def initialize 
	      @worksheets = Array.new

	    end
	    
	    # Add a sheet to the colleection of worksheets.
	    # * sheetname (string) is the name of the worksheet tab
	    # * objectType (string) is the type of object you're sending in.
	    #
	    # * objects is your collection of ActiveRecord objects.
	    #
	    # Here's an example
	    #    
	    #     @book = Book.find(:all)
	    #     @authors = Authors.find(:all)
	    #     addWorksheetFromActiveRecord "Books", "book", @book
	    #     addWorksheetFromActiveRecord "Authors", "author", @authors
	    def addWorksheetFromActiveRecord(sheetname, objectType, objects)
	      
	      objects = [objects] unless objects.class == Array
	    
	      item = [sheetname.to_s, objectType.to_s, objects]
	      @worksheets += [item]
	    end
	    
	    # Add a sheet to the colleection of worksheets.
	    # * sheetname (string) is the name of the worksheet tab
	    # * array (Array) is an array of Hashes that contain the data you want to render.
	    # ** It should be noted that the insertion order cannot be preserved.
	    #
	    # Here's an example
	    #    array = Array.new
	    #    item = Hash.new
	    #    item["Name"] = "John Smith"
	    #    item["Department"] = "Accounts Payable"
	    #    item["Location"] = "Chicago"
	    #    item["Salary"] = "$42,032"
	    #    item["Title"] = "Junior Accountant"
	    #    array << item
	    #    addWorksheetFromArrayOfHashes("Accounting info", array)
	    #
	    # Or, a more appropriate solution
	    #
	    #    books = Book.find(:all)
	    #    array = Array.new
	    #    for book in books
	    #      item = Hash.new
	    #      item["Title"] = book.title
	    #      item["ISBN"] = book.isbn
	    #      item["Author"] = book.author.last_name
	    #      item["Category"] = book.category.name
	    #      item["Total Sales"] = book.sales.size
	    #      array << item
	    #    end
	    #    addWorksheetFromArrayOfHashes("Books info", array)
	    #
	    # This solution would allow you to export a more useful view of your data by being able to
	    # export the values of your relationships to the Excel workbook.

	    def addWorksheetFromArrayOfHashes(sheetname, array)
	      item = [sheetname.to_s, 'array', array]
	      @worksheets += [item]
	    end
	
	    # Returns the Excel workbook in XML format.
	    # In the controller, set the content type appropriately to send this back.
	    #
	    # Example: 
	    #     headers['Content-Type'] = "application/vnd.ms-excel" 
	    #     render_text(e.build)
	    def build
	    	buffer = ""
		    xml = Builder::XmlMarkup.new(buffer)
		    xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
		    xml.Workbook({
		      'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet", 
		      'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
		      'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",    
		      'xmlns:html' => "http://www.w3.org/TR/REC-html40",
		      'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet" 
		      }) do
	    
			      xml.Styles do
			       xml.Style 'ss:ID' => 'Default', 'ss:Name' => 'Normal' do
			         xml.Alignment 'ss:Vertical' => 'Bottom'
			         xml.Borders
			         xml.Font 'ss:FontName' => 'Arial'
			         xml.Interior
			         xml.NumberFormat
			         xml.Protection
			       end
			       xml.Style 'ss:ID' => 's22' do
			         xml.NumberFormat 'ss:Format' => 'General Date'
			       end
			      end
			      
			      for object in @worksheets
		      		# use the << operator to prevent the < > and & characters from being converted.
		      		# this will concat them together.
		      		if object[1] =='array'
		      		 xml << worksheetFromArray(object[0], object[2])
		            else
		             xml << worksheet(object[0], object[1], object[2])
		            end
			      end # for records
			    end
			    
	    return xml.target! 
	  end
	
	
	  
	  private
	  
	  # renders an Excel worksheet.
	  # Paramters:
	  #
	  # * sheetname is the name for the worksheet
	  # * objectType is a string for the model type that you're exporting.  For example: if you have a collection of Author objects, "author" would be your type.
	  # * objects is a collection of ActiveRecord objects
	  def worksheet (sheetname, objectType,objects)
	
	      buffer =""
	      xm = Builder::XmlMarkup.new(buffer) # stream to the text buffer
	      type = ActiveRecord::Base.const_get(objectType.classify)
	    
	            xm.Worksheet 'ss:Name' => sheetname do
    	            xm.Table do
    	        
    	              # Header
    	              xm.Row do
    	                for column in type.columns do
    	                  xm.Cell do
    	                    xm.Data column.human_name, 'ss:Type' => 'String'
    	                  end
    	                end
    	              end
    	        
    	              # Rows
    	              for record in objects
    	                xm.Row do
    	                  for column in type.columns do
    	                    xm.Cell do
    	                     xm.Data record.send(column.name), 'ss:Type' => 'String'
    	                    end
    	                  end
    	                end
    	              end # for
    	        
    	            end # table
	          end #worksheet
	       
	      return xm.target!  # retrieves the buffer
	
	  end
	 
	 
	 def worksheetFromArray(sheetname, array)
	   	  buffer =""
	      xm = Builder::XmlMarkup.new(buffer) # stream to the text buffer
	      xm.Worksheet 'ss:Name' => sheetname do
	       xm.Table do
	         #header
	         xm.Row do 
	          
               for key in array[0].keys
                xm.Cell do
                  xm.Data key, 'ss:Type' => 'String'
                end
               end #for
	         end #row
	         
	         #data
	         for item in array
	          
	           xm.Row do 
    	           for value in item.values
    	             xm.Cell do
    	               xm.Data value, 'ss:Type' => 'String'
    	             end
    	           end
	           end
	         end
	         
	         
	       end #table
	      end #worksheet
	      return xm.target!  # retrieves the buffer
	 end  
	
	
	end
end

