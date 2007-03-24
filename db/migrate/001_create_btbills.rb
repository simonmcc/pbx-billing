class CreateBtbills < ActiveRecord::Migration
  def self.up
    create_table :btbills do |t|
       t.column :bill_date,   :datetime
       t.column :uploaded_by, :string
    end
  end

  def self.down
    drop_table :btbills
  end
end
