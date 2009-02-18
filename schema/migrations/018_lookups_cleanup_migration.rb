class LookupsCleanupMigration < ActiveRecord::Migration
  def self.up
    rename_column :committee_members, :politician_name, :govtrack_id
    [:bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id].each do |attrb|
      remove_column :politicians, attrb
    end  
  end

  def self.down
    rename_column :committee_members, :govtrack_id, :politician_name
    [:bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id].each do |attrb|
      add_column :politicians, attrb, :string
    end
  end
end
