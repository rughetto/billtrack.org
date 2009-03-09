module Merb
  module BillsHelper
    def issues_text
      has_permissions? ? 'Add' : 'Suggest'
    end  
    def icon_parade(max_length=10)
      # grab party info about sponsors
      parade = [ @bill.sponsors.first.party.name ]
      @bill.cosponsors.each do |s|
        parade << s.party.name
      end 
      # build image tags
      html = "<div class='icon_parade'>"
      html << image_tag( "#{parade.shift.downcase}_large.png")
      (0..([max_length - 2, parade.length - 2].min)).each do |index|
        party = parade[index].downcase
        html << image_tag( "#{parade[index].downcase}_small.png") if ['democrat', 'republican'].include?( party )
      end   
      html << "</div>"
      html
    end  
  end
end # Merb