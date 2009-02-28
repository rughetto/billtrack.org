require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Member do

  describe "validations" do
    before(:each) do
      Member.delete_all
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

end