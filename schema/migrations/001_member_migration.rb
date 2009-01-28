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
      t.string :zipcode
      t.string :party_affiliation
      
      t.timestamps
    end
    add_index :members, :username, :unique
    add_index :members, :zipcode
    add_index :members, :party_affiliation
  end

  def self.down
    drop_table :members
    remove_index :members, :username
    remove_index :members, :zipcode
    remove_index :members, :party_affiliation
  end
end
