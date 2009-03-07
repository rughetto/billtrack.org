class PoliticianIssueMigration < ActiveRecord::Migration
  def self.up
    create_table :politician_issues do |t|
      t.integer :politician_id
      t.integer :issue_id
      t.string  :type
      t.integer :issue_count, :default => 0
      t.decimal :score,       :precision => 5,  :scale => 2
      t.string  :politician_role
      t.integer :session
    end
    add_index :politician_issues, [:politician_id],   :name => "politician_issues_on_politician"
    add_index :politician_issues, [:issue_id],        :name => "politician_issues_on_issue"
  end

  def self.down
    remove_index :politician_issues, :name => "politician_issues_on_politician"
    remove_index :politician_issues, :name => "politician_issues_on_issue"
    
    drop_table :politician_issues
  end
end
