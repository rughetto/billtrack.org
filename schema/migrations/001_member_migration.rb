class MemberMigration < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :username
      t.string :salt
      t.string :crypted_password
      t.string :email
      
      # slice auth vars
      t.string    :password_reset_code        # merb-auth-slice-password-reset 
      t.datetime  :activated_at               # MerbAuthSliceActivation
      t.string    :activation_code            # MerbAuthSliceActivation
      t.datetime  :remember_token_expires_at  # merb-auth-remember-me
      t.string    :remember_token             # merb-auth-remember-me
      
      t.string :roles
      
      t.string  :first_name
      t.string  :last_name
      t.text    :visibility # hash {:first_name => true, :last_name => false, :zipcode => true}
      
      t.text    :address
      t.string  :city
      t.string  :zip_main
      t.string  :zip_plus_four
      t.string  :state_id
      
      t.integer :district_id
      t.integer :party_id
      
      t.timestamps
    end
    add_index :members, :username, :unique => true, :name => "members_name"
    add_index :members, :district_id,               :name => "members_district"
    add_index :members, :party_id,                  :name => "members_party"
  end

  def self.down
    remove_index :members, :name => :members_name
    remove_index :members, :name => :members_district
    remove_index :members, :name => :members_party
    drop_table :members
  end
end