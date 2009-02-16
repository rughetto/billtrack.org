class CommitteeBillMigration < ActiveRecord::Migration
  def self.up
    create_table :committee_bills do |t|
      t.integer :committee_id
      t.integer :bill_id
      t.string  :activity
      t.string  :committee_name
    end
    
    add_index :committee_bills, [:bill_id, :committee_id], :name => "committee_bills_ids"
  end

  def self.down
    remove_index :committee_bills, :name => "committee_bills_ids"
    drop_table :committee_bills
  end
end
