require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a politician exists" do
  Politician.delete_all
  request(resource(:politicians), :method => "POST", 
    :params => { :politician => { :id => nil }})
end

describe "resource(:politicians)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:politicians))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of politicians" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a politician exists" do
    before(:each) do
      @response = request(resource(:politicians))
    end
    
    it "has a list of politicians" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Politician.delete_all
          @response = request(resource(:politicians), :method => "POST", 
        :params => { :politician => { :id => nil }})
    end
    
    it "redirects to resource(:politicians)" do
      @response.should redirect_to(resource(Politician.first), :message => {:notice => "politician was successfully created"})
          end
    
  end
end

describe "resource(@politician)" do 
  describe "a successful DELETE", :given => "a politician exists" do
     before(:each) do
       @response = request(resource(Politician.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:politicians))
     end

   end
end

describe "resource(:politicians, :new)" do
  before(:each) do
    @response = request(resource(:politicians, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@politician, :edit)", :given => "a politician exists" do
  before(:each) do
    @response = request(resource(Politician.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@politician)", :given => "a politician exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Politician.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @politician = Politician.first
      @response = request(resource(@politician), :method => "PUT", 
        :params => { :politician => {:id => @politician.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@politician))
    end
  end
  
end

