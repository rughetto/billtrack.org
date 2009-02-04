class LivRelationshipMigration < ActiveRecord::Migration
  def self.up
    create_table :liv_relationships do |t|
      t.integer :parent_id
      t.integer :child_id 
    end
    
    remove_column :legislative_issues, :parent_id
    remove_column :legislative_issues, :lft
    remove_column :legislative_issues, :rgt
    remove_column :legislative_issues, :created_at
    remove_column :legislative_issues, :updated_at
  end

  def self.down
    drop_table :liv_relationships
    
    add_column :legislative_issues, :parent_id, :integer
    add_column :legislative_issues, :lft, :integer
    add_column :legislative_issues, :rgt, :integer
    add_column :legislative_issues, :created_at, :datetime
    add_column :legislative_issues, :updated_at, :datetime
  end
end
