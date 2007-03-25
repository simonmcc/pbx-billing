class CreateClientbills < ActiveRecord::Migration
  def self.up
    create_table :clientbills do |t|
	t.column :name, 	:string
	t.column :startdate,	:datetime
	t.column :enddate,	:datetime
	t.column :total,	:integer
    end
  end

  def self.down
    drop_table :clientbills
  end
end
