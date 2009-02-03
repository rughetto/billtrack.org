class CommitteeMemberMigration < ActiveRecord::Migration
  def self.up
    create_table :committee_members do |t|
      t.integer :committee_id
      t.integer :politician_id
      t.string  :politician_name # for double checking relationships
      t.string  :role
    end

    add_index :committee_members, [:committee_id, :politician_id], :name => "committee_member_ids"
  end

  def self.down
    remove_index :committee_members, :name => "committee_member_ids"
    drop_table :committee_members
  end
end
