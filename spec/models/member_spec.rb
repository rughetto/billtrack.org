require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Member do
  before(:each) do
    Member.delete_all
    @valid_hash = {
      :username => 'user',
      :password => 'password',
      :password_confirmation => 'password',
      :email => 'user@user.com',
      :zipcode => '11111'
    }
  end  

  describe "validations" do
    before(:each) do
      @member = Member.new( 
        :username => 'user',
        :password => 'password',
        :password_confirmation => 'password',
        :email => 'user@user.com',
        :zipcode => '11111'
      )
    end  
    
    it 'should be valid with valid username, email, password, password_confirmation, and zip' do
      @member.valid?
      @member.should be_valid
    end  
    
    it 'should have a unique username' do
      @member.save
      duplicate_member = Member.new(
        :username => 'user',
        :password => 'password',
        :password_confirmation => 'password_confirmation',
        :email => 'user2@user.com',
        :zipcode => '11111'
      )
      duplicate_member.should_not be_valid
      duplicate_member.errors.on(:username).should_not be_nil
    end  
    
    it 'username should only include alpha-numeric characters' do
      @member.username = '&*^%.,@#!'
      @member.should_not be_valid
      @member.errors.on(:username).should_not be_nil
    end
    
    it 'username should be three or more characters' do
      @member.username = 'aa'
      @member.should_not be_valid
      @member.errors.on(:username).should_not be_nil
    end  
      
    it 'username should not include whitespace' do
      @member.username = 'John Doe'
      @member.should_not be_valid
      @member.errors.on(:username).should_not be_nil
    end
      
    it 'should require an email' do
      @member.email = nil
      @member.should_not be_valid
      @member.errors.on(:email).should_not be_nil
    end
      
    it 'should require valid email format' do
      @member.email = 'not_a_valid_email'
      @member.should_not be_valid
      @member.errors.on(:email).should_not be_nil
    end
      
    it 'should require a unique email' do
      @member.save.should == true
      duplicate_member = Member.new( 
        :username => 'user2',
        :password => 'password',
        :password_confirmation => 'password',
        :email => 'user@user.com',
        :zipcode => '11111'
      )
      duplicate_member.should_not be_valid
      duplicate_member.errors.on('email').should_not be_nil
    end
      
    it 'should require a password if new' do
      @member.password = nil
      @member.should_not be_valid
      @member.errors.on(:password).should_not be_nil
    end
    
    it 'should not require a password if not a new record' do
      @member.save
      @member.should_not be_new_record
      @member.password = nil
      @member.username = 'something_new' # to trigger saving of the record
      @member.should be_valid
    end 
    
    it 'password should be at least 6 characters' do
      @member.password = 'duh!!'
      @member.password_confirmation = @member.password
      @member.should_not be_valid
      @member.errors.on(:password).should_not be_nil
    end   
      
    it 'should require a password_confirmation if password is being set' do
      @member.password_confirmation = nil
      @member.should_not be_valid
      @member.errors.on(:password_confirmation).should_not be_nil
    end
      
    it 'should require a zipcode' do
      @member.zipcode = nil
      @member.should_not be_valid
      @member.errors.on(:zipcode).should_not be_nil
    end  
    
    it 'zipcode should be of valid 5-digit or +4 format' do
      @member.zipcode = '111'
      @member.should_not be_valid
      @member.errors.on(:zipcode).should_not be_nil
      @member.zipcode = '11111'
      @member.should be_valid
      @member.errors.on(:zipcode).should be_nil
      @member.zipcode = '11111-1111'
      @member.should be_valid
      @member.errors.on(:zipcode).should be_nil
    end  
  end  

  describe "roles and permissions: " do
    before(:each) do
      @member = Member.new
    end  
    
    it "roles should return an array" do
      @member[:roles] = 'admin, issues'
      @member.roles.class.should == Array
    end
      
    it 'roles array should contain a set of symbols' do
      @member[:roles] = 'admin, issues'
      @member.roles.each do |role|
        role.class.should == Symbol
      end  
      # testing return of array values when passed an array of strings
      @member[:roles] = nil
      @member.roles = ['admin', 'issues']
      @member.roles.each do |role|
        role.class.should == Symbol
      end  
    end
      
    it 'roles= should take either a string or an array' do
      lambda {@member.roles = 'admin, issues'}.should_not raise_error
      lambda {@member.roles = [:this, :that] }.should_not raise_error
      lambda {@member.roles = {}}.should raise_error
    end
      
    it 'roles should only output values in Member.acceptable_roles' do
      @member.roles = 'admin, issues, garbage'
      @member.roles.should == [:admin, :issues]
    end  
    
    it 'has_permissions? should always be true if roles include :admin' do
      @member.roles = 'admin'
      @member.has_permissions?( 'Anything' ).should == true
    end
      
    it 'has_permissions? should be true if roles include symbol related to controller' do
      controller = mock('Issues')
      controller.stub!(:to_s).and_return( 'Issues' )
      @member.roles = 'issues'
      @member.has_permissions?( controller ).should == true
    end  
    
    it 'has_permissions? should be false if not an admin and does not have permissions for the controller' do
      controller = mock('Issues')
      controller.stub!(:to_s).and_return( 'Issues' )
      @member.has_permissions?( controller ).should == false
    end  
  end  

  describe 'districting' do
    before(:all) do
      District.delete_all
      DistrictMap.delete_all
      # zip within one district 94102
      d = District.create( :state => 'CA', :number => 8 )
      d.should_not be_new_record
      dm = DistrictMap.create( :district_id => d.id, :zipcode => '94102' )
      dm.should_not be_new_record
      
      # zip has many districts 
      d = District.create( :state => 'NC', :number => 13 )
      d.should_not be_new_record
      dm = DistrictMap.create( :district_id => d.id, :zipcode => '27511')
      dm.should_not be_new_record
      d = District.create( :state => 'NC', :number => 4 )
      d.should_not be_new_record
      dm = DistrictMap.create( :district_id => d.id, :zipcode => '27511')
      dm.should_not be_new_record
    
      @complex_zip_hash = {
        :zipcode => '27511',
        :address => '900 Ralph Drive',
        :city => 'Cary',
        :state => State.find_by_code('NC')
      }
    end  
    
    it '#find_district should set district_id when there is only one district_map' do
      member = Member.create( @valid_hash.merge( :zipcode => '94102') )
      d = member.find_district
      d.should_not be_nil
      d.state.should == 'CA'
      d.number.should == 8
      member.district_id.should_not be_nil
    end 
    
    it '#find_district should determine the district_id with a valid address and zip' do
      member = Member.create( @valid_hash.merge( @complex_zip_hash ) )
      d = member.find_district
      member.district_id.should_not be_nil
      d.should_not be_nil
      d.state.should == 'NC'
      d.number.should == 13
    end 
    
    it '#district_changing? should be true for new records' do
      member = Member.new( @valid_hash.merge( @complex_zip_hash ) )
      member.should be_district_changing
    end
    
    it '#district_changing? should non be true for saved records without an address change' do
      member = Member.create( @valid_hash.merge( @complex_zip_hash ) )
      member.should_not be_new_record
      member.reload
      member.should_not be_district_changing
    end  
    
    it '#district_changing? should be true when any part of an address changes' do
      member = Member.create( @valid_hash.merge( @complex_zip_hash ) )
      member.should_not be_new_record
      member.reload
      member.zipcode = '10012'
      member.should be_district_changing
    end  
    
    it 'should assign district on create' do
      member = Member.create( @valid_hash.merge( :zipcode => '94102') )
      member.should_not be_new_record
      member.district.should_not be_nil
    end  
    
    it 'should save district information on create' do
      member = Member.create( @valid_hash.merge( :zipcode => '94102') )
      member.reload
      member.district.should_not be_nil
    end  
  end  
end