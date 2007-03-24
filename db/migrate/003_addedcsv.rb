class Addedcsv < ActiveRecord::Migration
  def self.up
	add_column "btbills", "billcsv", :string
  end

  def self.down
	remove_column "btbills", "billcsv"
  end
end
