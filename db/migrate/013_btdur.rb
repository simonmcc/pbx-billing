class Btdur < ActiveRecord::Migration
  def self.up
	remove_column "btbilldetails", "duration"
	add_column "btbilldetails", "duration", :integer
  end

  def self.down
  end
end
