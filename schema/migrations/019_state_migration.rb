class StateMigration < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string  :code
      t.string  :name
      t.string  :latitude
      t.string  :longitude
      t.integer :party_id
      t.string  :zoom_level 
    end
    add_index :states, :code, :name => :state_codes
  end

  def self.down
    remove_index :states, :name => :state_codes
    drop_table :states
  end
end
