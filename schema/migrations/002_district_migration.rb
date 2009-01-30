class DistrictMigration < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.string  :state
      t.integer :number
    end
    add_index :districts, [:state, :number], :name => "districts_state_number"
  end

  def self.down
    remove_index    :districts, :name => :districts_state_number
    drop_table  :districts
  end
end
