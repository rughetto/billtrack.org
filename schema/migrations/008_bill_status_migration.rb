class BillStatusMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_statuses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bill_statuses
  end
end
