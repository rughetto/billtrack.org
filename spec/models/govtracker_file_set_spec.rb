require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe GovtrackerFileSet do
  before(:all) do
    GovtrackerFileSet.root_directory = "#{Merb.root}/spec/xml/"
  end  
  
  it "should require a :dir parameter in the initialization options" do
    lambda { GovtrackerFileSet.new({:tag => 'bill'}) }.should raise_error
  end 
   
  it "should initialize without error when given a :dir parameter in the options hash" do
    lambda { GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'}) }.should_not raise_error
  end
    
  it "should find the files" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.files.size.should == 2
    set.files.first.should == 'h1.xml'
  end
    
  it "should return an instance of GovtrackerFileSet" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.class.should == GovtrackerFileSet
  end
    
  it "should instantiate the first GovtrackerFile object in the files array" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.current.class.should == GovtrackerFile
    set.current.file.should include( set.files[0] )
  end
  
  it "should be able to jump to an object by index number using the [integer] method" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    last = set[1]
    last.class.should == GovtrackerFile
    last.file.should include( set.files[1] )
  end  
  
  it "should be able to jump to an object by file name using the [String] method" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    last = set['h100.xml']
    last.class.should == GovtrackerFile
    last.file.should include( set.files[1] )
  end  
  
  it "should not move the marker when jumping to a particular object using []" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    last = set['h100.xml']
    set.marker.should == 0
  end 
  
  it "#next should return the next GovtrackerFile object" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.next.file.should == set[1].file
  end  
  
  it "#next should advance the marker" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.next
    set.marker.should == 1
  end   
  
  it "#previous should return the previous GovtrackerFile object" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.marker = 1
    set.previous.file.should == set[0].file
  end
    
  it "#previous should decrement the marker" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.marker = 1
    set.previous
    set.marker.should == 0
  end
    
  it "#next and #previous should return nil if they run out of files at either end" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.previous.should be_nil
    set.next
    set.next.should be_nil
  end
    
  it "should rewind" do
    set = GovtrackerFileSet.new({:tag => 'bill', :dir => '111/bills'})
    set.next
    set.marker.should == 1
    set.rewind
    set.marker.should == 0
    set.current.file.should == set[0].file
  end  
  
end