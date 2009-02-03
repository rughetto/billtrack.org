class BillActionMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_actions do |t|
      t.string    :type # vote or action
      t.integer   :bill_id
      t.datetime  :timestamp
      t.string    :reference
      t.string    :reference_label
      t.string    :bill_type # bill or ammendment
    end
    
    add_index :bill_actions, [:bill_id], :name => "bill_action_bill_id"
  end

  def self.down
    remove_index :bill_actions, :name => "bill_action_bill_id"
    drop_table :bill_actions
  end
end
