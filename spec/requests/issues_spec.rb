require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a issue exists" do
  Issue.delete_all
  request(resource(:issues), :method => "POST", 
    :params => { :issue => { :id => nil }})
end

describe "resource(:issues)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:issues))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of issues" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a issue exists" do
    before(:each) do
      @response = request(resource(:issues))
    end
    
    it "has a list of issues" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Issue.delete_all
          @response = request(resource(:issues), :method => "POST", 
        :params => { :issue => { :id => nil }})
    end
    
    it "redirects to resource(:issues)" do
      @response.should redirect_to(resource(Issue.first), :message => {:notice => "issue was successfully created"})
          end
    
  end
end

describe "resource(@issue)" do 
  describe "a successful DELETE", :given => "a issue exists" do
     before(:each) do
       @response = request(resource(Issue.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:issues))
     end

   end
end

describe "resource(:issues, :new)" do
  before(:each) do
    @response = request(resource(:issues, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@issue, :edit)", :given => "a issue exists" do
  before(:each) do
    @response = request(resource(Issue.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@issue)", :given => "a issue exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Issue.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @issue = Issue.first
      @response = request(resource(@issue), :method => "PUT", 
        :params => { :issue => {:id => @issue.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@issue))
    end
  end
  
end

