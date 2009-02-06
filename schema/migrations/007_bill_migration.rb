class BillMigration < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :type # Bill/null or Ammendment
      t.string :congressional_session # currently 111
      t.string :chamber # h, s, etc
      t.string :number
      t.string :sequence # if ammendment
      t.integer :parent_id # null if bill, self-referencing relationship if ammendment
      t.string :parent_name # in case unable to find parent
      t.datetime  :introduced_at
      t.string    :short_title
      t.text      :title
      t.datetime  :xml_updated_at
    end
    
    add_index :bills, [:chamber, :number], :name => "bill_identity"
    add_index :bills, [:id], :name => "bill_id"
    add_index :bills, [:parent_id], :name => "bill_parent"
  end

  def self.down
    remove_index :bills, :name => "bill_identity"
    remove_index :bills, :name => "bill_id"
    remove_index :bills, :name => "bill_parent"
    drop_table :bills
  end
end
