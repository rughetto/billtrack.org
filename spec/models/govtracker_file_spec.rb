require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe GovtrackerFile do
  # this should be broken out into shared specs
  describe "common class methods" do
    it "all object instances should have the same root directory for the govtrack_us data sets" do
      GovtrackerFile.root_directory = nil # reset to default
      GovtrackerFile.root_directory.should match(/govtrack_us/)
      new_obj = GovtrackerFile.new
      new_obj.class.root_directory.should match(/govtrack_us/)
    end  
    
    it "should allow the setting of the govtrack_us root directory" do
      set_path = "#{Merb.root}/spec/xml/"
      GovtrackerFile.root_directory = set_path
      GovtrackerFile.root_directory.should_not match(/govtrack_us/)
    end
      
    it "should determine the current congressional session" do
      GovtrackerFile.root_directory = nil # reset
      GovtrackerFile.current_session.should == '111'
    end
  end  
  
  it "should initialize without error given valid options" do
    lambda {
      liv = GovtrackerFile.new(:file => "liv.xml", :tag => "top-term")
    }.should_not raise_error
  end
    
  it "should successfully seach for a tag for when explicitly and implicitly declared" do
    GovtrackerFile.root_directory = "#{Merb.root}/spec/xml/"
    liv = GovtrackerFile.new(:file => 'liv.xml', :tag => 'top-term')
    a1 = liv.search(:value => 'Abortion')
    a1.should_not be_blank
    liv.search(:value => 'Zulu Martian').should be_blank
    a2 = liv.search(:term => {:value => 'Abortion'})
    a2.should_not be_blank
    a1.should_not == a2
  end
    
  it "should list all tag attributes" do
    GovtrackerFile.root_directory = "#{Merb.root}/spec/xml/"
    liv = GovtrackerFile.new(:file => 'liv.xml', :tag => 'top-term')
    liv.attributes.size.should == 1
  end
    
end  