require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a party exists" do
  Party.delete_all
  request(resource(:parties), :method => "POST", 
    :params => { :party => { :id => nil }})
end

describe "resource(:parties)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:parties))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of parties" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a party exists" do
    before(:each) do
      @response = request(resource(:parties))
    end
    
    it "has a list of parties" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Party.delete_all
          @response = request(resource(:parties), :method => "POST", 
        :params => { :party => { :id => nil }})
    end
    
    it "redirects to resource(:parties)" do
      @response.should redirect_to(resource(Party.first), :message => {:notice => "party was successfully created"})
          end
    
  end
end

describe "resource(@party)" do 
  describe "a successful DELETE", :given => "a party exists" do
     before(:each) do
       @response = request(resource(Party.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:parties))
     end

   end
end

describe "resource(:parties, :new)" do
  before(:each) do
    @response = request(resource(:parties, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@party, :edit)", :given => "a party exists" do
  before(:each) do
    @response = request(resource(Party.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@party)", :given => "a party exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Party.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @party = Party.first
      @response = request(resource(@party), :method => "PUT", 
        :params => { :party => {:id => @party.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@party))
    end
  end
  
end

