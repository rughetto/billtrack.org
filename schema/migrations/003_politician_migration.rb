class PoliticianMigration < ActiveRecord::Migration
  def self.up
    create_table :politicians do |t|
      t.string :type
      
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :name_suffix
      t.string :nickname
      t.string :gender
      
      t.integer :party_id
      t.string  :state
      t.string  :district_number # only applicable for reps
      t.integer :district_id # only applicable for reps
      t.string  :seat # only applicable for senators
      t.boolean :active, :default => true
      
      t.string  :phone
      t.string  :website
      t.string  :webform
      t.string  :email
      
      t.string  :eventful_id
      t.string  :congresspedia_url
      t.string  :twitter_id
      t.string  :youtube_url
      
      t.string  :bioguide_id
      t.string  :votesmart_id
      t.string  :fec_id
      t.string  :govtrack_id
      t.string  :crp_id
      
      t.timestamps
    end
    add_index :politicians, :party_id, :name => :politicians_party
    add_index :politicians, :state, :name => :politicians_state
    add_index :politicians, :district_id, :name => :politicians_district
  end

  def self.down
    remove_index :politicians, :name => :politicians_party
    remove_index :politicians, :name => :politicians_state
    remove_index :politicians, :name => :politicians_district
    drop_table :politicians
  end
end
