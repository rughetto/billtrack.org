require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a bill exists" do
  Bill.delete_all
  request(resource(:bills), :method => "POST", 
    :params => { :bill => { :id => nil }})
end

describe "resource(:bills)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:bills))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of bills" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a bill exists" do
    before(:each) do
      @response = request(resource(:bills))
    end
    
    it "has a list of bills" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Bill.delete_all
          @response = request(resource(:bills), :method => "POST", 
        :params => { :bill => { :id => nil }})
    end
    
    it "redirects to resource(:bills)" do
      @response.should redirect_to(resource(Bill.first), :message => {:notice => "bill was successfully created"})
          end
    
  end
end

describe "resource(@bill)" do 
  describe "a successful DELETE", :given => "a bill exists" do
     before(:each) do
       @response = request(resource(Bill.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:bills))
     end

   end
end

describe "resource(:bills, :new)" do
  before(:each) do
    @response = request(resource(:bills, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bill, :edit)", :given => "a bill exists" do
  before(:each) do
    @response = request(resource(Bill.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bill)", :given => "a bill exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Bill.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @bill = Bill.first
      @response = request(resource(@bill), :method => "PUT", 
        :params => { :bill => {:id => @bill.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@bill))
    end
  end
  
end

