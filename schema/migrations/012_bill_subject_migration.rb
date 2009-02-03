class BillSubjectMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_subjects do |t|
      t.integer :bill_id
      t.integer :legislative_issue_id
    end
    
    add_index :bill_subjects, [:bill_id, :legislative_issue_id], :name => "bill_subjects_ids"
  end

  def self.down
    remove_index :bill_subjects, :name => "bill_subjects_ids"
    drop_table :bill_subjects
  end
end
