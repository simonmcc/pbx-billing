class BtbillDesc < ActiveRecord::Migration
  def self.up
       add_column "btbills", "description", :string
  end

  def self.down
       remove_column "btbills", "description"
  end
end
