class CommitteeBillMigration < ActiveRecord::Migration
  def self.up
    create_table :committee_bills do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :committee_bills
  end
end
