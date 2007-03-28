class ClientEndext < ActiveRecord::Migration
  def self.up
	rename_column "clients", "extensions", "startext"
	add_column "clients", "endext", :integer
  end

  def self.down
  end
end
