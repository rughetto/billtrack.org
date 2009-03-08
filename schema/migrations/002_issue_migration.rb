class IssueMigration < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string  :name
      t.string  :status
      t.string  :stance_positive
      t.string  :stance_negative
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :suggested_by # Member
      t.integer :usage_count, :default => 0
    end
    
    add_index :issues, [:lft], :name => "issues_lft"
    add_index :issues, [:rgt], :name => "issues_rgt"
  end

  def self.down
    remove_index :issues, :name => "issues_lft"
    remove_index :issues, :name => "issues_rgt"
    
    drop_table :issues
  end
end
