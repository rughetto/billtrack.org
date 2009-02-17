class LookupMigration < ActiveRecord::Migration
  def self.up
    create_table :name_lookups do |t|
      t.integer   :parent_id
      t.string    :parent_type
      t.text      :name
    end
    create_table :id_lookups do |t|
      t.integer   :parent_id
      t.string    :parent_type
      t.string    :additional_id
      t.string    :id_type
    end
  end

  def self.down
    drop_table :name_lookups
    drop_table :id_lookups
  end
end
