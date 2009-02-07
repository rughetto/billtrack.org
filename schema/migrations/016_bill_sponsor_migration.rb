class BillSponsorMigration < ActiveRecord::Migration
  def self.up
    create_table :bill_sponsors do |t|
      t.integer :bill_id
      t.integer :politician_id
      t.date    :joined_on
      t.string  :govtrack_id
      t.string  :type # sponsor, cosponsor
    end
    add_index :bill_sponsors, [:bill_id, :politician_id], :name => "bill_sponsor_ids"
  end

  def self.down
    remove_index :bill_sponsors, :name => "bill_sponsor_ids"
    drop_table :bill_sponsors
  end
end
