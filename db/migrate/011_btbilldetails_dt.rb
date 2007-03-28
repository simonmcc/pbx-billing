class BtbilldetailsDt < ActiveRecord::Migration
  def self.up
    remove_column("btbilldetails", "date")
    remove_column("btbilldetails", "time")
    add_column("btbilldetails", "dt", :datetime)
  end

  def self.down
  end
end
