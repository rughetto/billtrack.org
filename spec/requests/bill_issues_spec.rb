require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a bill_issue exists" do
  BillIssue.delete_all
  request(resource(:bill_issues), :method => "POST", 
    :params => { :bill_issue => { :id => nil }})
end

describe "resource(:bill_issues)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:bill_issues))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of bill_issues" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a bill_issue exists" do
    before(:each) do
      @response = request(resource(:bill_issues))
    end
    
    it "has a list of bill_issues" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      BillIssue.delete_all
          @response = request(resource(:bill_issues), :method => "POST", 
        :params => { :bill_issue => { :id => nil }})
    end
    
    it "redirects to resource(:bill_issues)" do
      @response.should redirect_to(resource(BillIssue.first), :message => {:notice => "bill_issue was successfully created"})
          end
    
  end
end

describe "resource(@bill_issue)" do 
  describe "a successful DELETE", :given => "a bill_issue exists" do
     before(:each) do
       @response = request(resource(BillIssue.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:bill_issues))
     end

   end
end

describe "resource(:bill_issues, :new)" do
  before(:each) do
    @response = request(resource(:bill_issues, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bill_issue, :edit)", :given => "a bill_issue exists" do
  before(:each) do
    @response = request(resource(BillIssue.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bill_issue)", :given => "a bill_issue exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(BillIssue.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @bill_issue = BillIssue.first
      @response = request(resource(@bill_issue), :method => "PUT", 
        :params => { :bill_issue => {:id => @bill_issue.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@bill_issue))
    end
  end
  
end

