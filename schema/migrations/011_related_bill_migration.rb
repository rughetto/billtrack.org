class RelatedBillMigration < ActiveRecord::Migration
  def self.up
    create_table :related_bills do |t|
      t.integer :bill_id
      t.integer :related_bill_id
      t.string  :relationship
      t.string  :related_bill_data
    end
    
    add_index :related_bills, [:bill_id, :related_bill_id], :name => "related_bill_ids"
  end

  def self.down
    remove_index   :related_bills, :name => "related_bill_ids"
    drop_table :related_bills
  end
end
