class Dropcsv < ActiveRecord::Migration
  def self.up
	remove_column "btbills", "billcsv"
  end

  def self.down
  end
end
