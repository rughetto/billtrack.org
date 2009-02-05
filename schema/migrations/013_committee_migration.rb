class CommitteeMigration < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.string  :name
      t.string  :chamber
      t.string  :url
      t.string  :code
      t.integer :parent_id
      t.string  :congressional_session
    end
    add_index :committees, [:id], :name => "committee_id"
    add_index :committees, [:parent_id], :name => "committee_parents"
  end

  def self.down
    remove_index :committees, :name => "committee_id"
    remove_index :committees, :name => "committee_parents"
    drop_table :committees
  end
end
