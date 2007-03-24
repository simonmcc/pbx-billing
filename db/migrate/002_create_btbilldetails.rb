class CreateBtbilldetails < ActiveRecord::Migration
  def self.up
    create_table :btbilldetails do |t|
        t.column :chargecode,           :string
        t.column :installationno,       :string
        t.column :lineno,               :string
        t.column :chargecardno,         :string
        t.column :date,                 :string
        t.column :time,                 :string
        t.column :destination,          :string
        t.column :calledno,             :string
        t.column :duration,             :string
        t.column :txtdirectrebate,      :string
        t.column :cost,                 :string
    end
  end

  def self.down
    drop_table :btbilldetails
  end
end
