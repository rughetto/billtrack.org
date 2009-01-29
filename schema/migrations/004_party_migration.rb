class PartyMigration < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string  :abbreviation
      t.string  :name
      t.string  :website
      t.timestamps
    end
    # I want to cache these records into memory, so I am not going to add any indexes for the table
  end

  def self.down
    drop_table :parties
  end
end
