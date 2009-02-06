class BillStatusMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_statuses do |t|
      t.integer :bill_id
      t.date    :date
      t.string  :chamber # where in bill statuses
      t.string  :result
      t.string  :method
      t.string  :details
      t.string  :status_type # vote, introduced, etc. name of tag inside bill<status tag
    end
    
    add_index :bill_statuses, [:bill_id], :name => "bill_status_bill_id"
  end

  def self.down
    remove_index :bill_statuses, :name => "bill_status_bill_id"
    drop_table :bill_statuses
  end
end
