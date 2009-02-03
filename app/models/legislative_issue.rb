require 'hpricot'
class LegislativeIssue < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :parent, :class_name => "LegeslativeIssue", :foreign_key => "parent_id"
  
  validates_uniqueness_of :name
  
  def self.hpricoted
    Hpricot.parse(File.open("#{Merb.root}/schema/govtract_us/liv.xml"))
  end  
  
  def self.batch_import
    (hpricoted/"top-term".to_sym).each do |top_term|
      puts top_term.get_attribute('value')
      parent = find_or_create_by_name( top_term.get_attribute('value') )
      (top_term/:term).each do |tag|
        puts "  " + tag.get_attribute('value')
        child = find_or_create_by_name( tag.get_attribute('value'))
        child.move_to_child_of(parent) unless parent == child
      end  
    end
  end

end
