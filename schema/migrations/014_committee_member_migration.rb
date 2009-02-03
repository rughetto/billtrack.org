class CommitteeMemberMigration < ActiveRecord::Migration
  def self.up
    create_table :committee_members do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :committee_members
  end
end
