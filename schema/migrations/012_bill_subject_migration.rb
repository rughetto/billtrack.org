class BillSubjectMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_subjects do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :bill_subjects
  end
end
