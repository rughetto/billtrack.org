require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a district exists" do
  District.delete_all
  request(resource(:districts), :method => "POST", 
    :params => { :district => { :id => nil }})
end

describe "resource(:districts)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:districts))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of districts" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a district exists" do
    before(:each) do
      @response = request(resource(:districts))
    end
    
    it "has a list of districts" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      District.delete_all
          @response = request(resource(:districts), :method => "POST", 
        :params => { :district => { :id => nil }})
    end
    
    it "redirects to resource(:districts)" do
      @response.should redirect_to(resource(District.first), :message => {:notice => "district was successfully created"})
          end
    
  end
end

describe "resource(@district)" do 
  describe "a successful DELETE", :given => "a district exists" do
     before(:each) do
       @response = request(resource(District.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:districts))
     end

   end
end

describe "resource(:districts, :new)" do
  before(:each) do
    @response = request(resource(:districts, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@district, :edit)", :given => "a district exists" do
  before(:each) do
    @response = request(resource(District.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@district)", :given => "a district exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(District.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @district = District.first
      @response = request(resource(@district), :method => "PUT", 
        :params => { :district => {:id => @district.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@district))
    end
  end
  
end

