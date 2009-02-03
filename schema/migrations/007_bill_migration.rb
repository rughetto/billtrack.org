class BillMigration < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
