class RelatedBillMigration < ActiveRecord::Migration
  def self.up
    create_table :related_bills do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :related_bills
  end
end
