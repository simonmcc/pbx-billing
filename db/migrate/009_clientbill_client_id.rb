class ClientbillClientId < ActiveRecord::Migration
  def self.up
	add_column "clientbills", "client_id", :integer
  end

  def self.down
	remove_column "clientbills", "client_id"
  end
end
