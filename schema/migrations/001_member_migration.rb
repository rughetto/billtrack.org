class MemberMigration < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :username, :null => false
      t.string :salt
      t.string :crypted_password
      
      t.string :auth_token
      t.datetime :remember_until
      
      t.string :status
      t.string :roles
      
      t.string :first_name
      t.string :last_name
      t.text :visibility
      
      t.text :address
      t.string :city
      t.string :zipcode
      t.string :state
      t.integer :district_id
      t.integer :party_id
      
      t.timestamps
    end
    add_index :members, :username, :unique => true, :name => "members_name"
    add_index :members, :district_id, :name => "members_district"
    add_index :members, :party_id, :name => "members_party"
  end

  def self.down
    remove_index :members, :name => :members_name
    remove_index :members, :name => :members_district
    remove_index :members, :name => :members_party
    drop_table :members
  end
end
