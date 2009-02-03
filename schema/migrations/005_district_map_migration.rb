class DistrictMapMigration < ActiveRecord::Migration
  def self.up
    create_table :district_maps do |t|
      t.integer  :district_id
      t.string  :zip_main
      t.string  :zip_plus_four
      t.boolean :complex, :default => false
      t.timestamps
    end
    add_index :district_maps, [:district_id, :zip_main], :name => :district_zip_main
    add_index :district_maps, [:district_id, :zip_main, :zip_plus_four], :name => :district_zip_full
  end

  def self.down
    remove_index :district_maps, :name => :district_zip_main
    remove_index :district_maps, :name => :district_zip_full
    drop_table :district_maps
  end
end
