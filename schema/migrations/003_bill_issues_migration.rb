class BillIssuesMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_issues do |t|
      t.integer :bill_id
      t.integer :issue_id
    end
    
    add_index :bill_issues, [:bill_id],   :name => "bill_issues_on_bill"
    add_index :bill_issues, [:issue_id],  :name => "bill_issues_on_issue"
  end

  def self.down
    remove_index :bill_issues, :name => "bill_issues_on_bill"
    remove_index :bill_issues, :name => "bill_issues_on_issue"
    drop_table :bill_issues
  end
end
