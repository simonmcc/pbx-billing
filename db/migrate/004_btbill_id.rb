class BtbillId < ActiveRecord::Migration
  def self.up
    add_column "btbilldetails", "btbill_id", :integer
  end

  def self.down
  end
end
