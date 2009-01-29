class DistrictMigration < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.string  :state
      t.integer :number
      t.string  :zipcode
    end
    add_index :districts, [:state, :number], :name => "districts_state_number"
    add_index :districts, :zipcode, :name => "districts_zipcode"
  end

  def self.down
    remove_index    :districts, :name => :districts_state_number
    remove_index    :districts, :name => :districts_zipcode
    drop_table  :districts
  end
end
