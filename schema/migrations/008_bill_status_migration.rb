class BillStatusMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_statuses do |t|
      t.integer :bill_id
      t.string  :chamber
      t.date    :date
      t.string  :result
      t.method  :method
    end
    
    add_index :bill_statuses, [:bill_id], :name => "bill_status_bill_id"
  end

  def self.down
    remove_index :bill_statuses, :name => "bill_status_bill_id"
    drop_table :bill_statuses
  end
end
