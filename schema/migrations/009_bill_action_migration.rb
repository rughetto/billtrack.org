class BillActionMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_actions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bill_actions
  end
end
