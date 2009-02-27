require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Bill do
  describe "text helpers" do
    before(:each) do
      @bill = Bill.new(:congressional_session => '111', :chamber => 'hr', :number => '13')
    end  
    
    it '#title_short should be #short_title if #short_title is not blank' do
      @bill.title = "Long title"
      @bill.short_title = 'Short title'
      @bill.title_short.should == @bill.short_title
    end  
    
    it '#title_short should be #title if #short_title is blank' do
      @bill.title = "Long title"
      @bill.short_title = ''
      @bill.title_short.should == @bill.title
      @bill.short_title = nil
      @bill.title_short.should == @bill.title
    end  
    
    it '#split_chamber should capitalize the chamber and seperate each letter with a period' do
      @bill.split_chamber.should == 'H.R.'
    end
      
    it '#id_number should include the #split_chamber and the bill #number' do
      @bill.id_number.should match( Regexp.new(@bill.split_chamber) )
      @bill.id_number.should match( Regexp.new(@bill.number) )
    end  
    
  end  
end