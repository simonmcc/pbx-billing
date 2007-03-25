class CreateClientcdrs < ActiveRecord::Migration
  def self.up
    create_table :clientcdrs do |t|
    end
  end

  def self.down
    drop_table :clientcdrs
  end
end
