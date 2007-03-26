class CreateClientcdrs < ActiveRecord::Migration
  def self.up
    create_table :clientcdrs do |t|
	t.column :clientbill_id,	:integer
	t.column :src,			:string
	t.column :dst,			:string
	t.column :dt,			:datetime
	t.column :cost,			:float
    end
  end

  def self.down
    drop_table :clientcdrs
  end
end
