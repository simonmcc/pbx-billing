#=EXCEL plugin
# Created 2005 Brian P. Hogan / NAPCS
# Open to the public, no rights reserved.
# Free for use by anyone for any purpose. 
#===
#=Purpose
#==Active Record spreadsheets
# This plugin was designed as a quick and easy way for developers using ActiveRecord objects to
# easily export their object collections to an Excel workbook.
# Each model object is mapped to a separate worksheet. 
#==Array of Hashes spreadsheets
# Additionally, developers can define their own worksheet by defining an array of hashes. The keys of
# the hash are used as the column headings, and the values of the hash are used as the data. 
# Though the insertion order is not preserved, this plugin should accept any subclass of Hash, provided
# that #keys and #values are still available. This means that you could override Hash with an implementation
# that preserves the sorting. However, this has not been tested.
#===
#=How to install
# Copy the *Excel* folder and its contents to the *vendor/plugins* of your Rails application and restart your web server. The plugin will automatically be loaded and ready for you to use.
#===
#=Simple example
# Let's assume we have two models... a Project and a Task.  
# A Project has_many :tasks.
# In one of our controllers, we can create the following method which will stream a new Microsoft Excel document to the client's browser.
#
#   def export_project_to_excel
#     e = Excel::Workbook
#     @project = Project.find(:all)
#     @tasks = @project.tasks
#     e.addWorksheetFromActiveRecord "Project", "project", @project
#     e.addWorksheetFromActiveRecord "Tasks", "task", @tasks
#     headers['Content-Type'] = "application/vnd.ms-excel" 
#     render_text(e.build)
#   end
#===
#=More Advanced example
# This time, let's create an array of hashes. This way, we can manipulate our data ourselves, instead
# of letting the plugin do the mapping. This is really useful when you have "has_many" or "belongs to"
# relationships and you want to export meaningful values instead of the foreign keys.
#
#   def export_book_info_to_excel 
#     books = Book.find(:all)
#     array = Array.new
#     for book in books
#       item = Hash.new
#        item["Title"] = book.title
#        item["ISBN"] = book.isbn
#        item["Author"] = book.author.last_name
#        item["Category"] = book.category.name
#        item["Total Sales"] = book.sales.size
#        array << item
#     end
#     addWorksheetFromArrayOfHashes("Books info", array)
#     headers['Content-Type'] = "application/vnd.ms-excel" 
#     render_text(e.build)
#   end
#===
#=Todo
#==Title, author, other metadata
#===
#=Credits
# Original code for the creation of the XML document for the Excel spreadsheet comes from the Rails WIKI. Thanks to david@vallner.net for the example.
# See the original article here : http://wiki.rubyonrails.com/rails/pages/HowToExportToExcel
require 'excel'