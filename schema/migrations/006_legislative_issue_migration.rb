class LegislativeIssueMigration < ActiveRecord::Migration
  def self.up
    create_table :legislative_issues do |t|
      t.string  :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
    # no indexes yet; this should be for reference mainly
  end

  def self.down
    drop_table :legislative_issues
  end
end
