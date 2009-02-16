class BillAction < ActiveRecord::Base
  # ATTRIBUTES ======================
  # t.string    :type # vote or action
  # t.integer   :bill_id
  # t.datetime  :action_time
  # t.string    :reference
  # t.string    :reference_label
  # t.string    :description
  # t.string    :vote_result # for votes only
  # t.string    :vote_method # for votes only
    
  # IMPORTING =======================  
  def self.import_set(xml, b)
    set = []
    (xml/:action).each do |action_xml |
      set << import( action_xml, b ) unless action_xml.blank?
    end
    (xml/:vote).each do |vote_xml |  
      set << BillVote.import( vote_xml, b ) unless vote_xml.blank?
    end 
    set 
  end 
  
  def self.import( action_xml, b )
    record = find_or_create_by( identity_hash( action_xml, b ) )
    record.update_attributes( update_hash( action_xml ) )
    @attrs = nil # clear class level instance variables for use with next record
    record
  end   
  
  private 
    def self.identity_hash( action_xml, b )
      hash = attrs( action_xml )
      identity_hash = {
        :action_time => hash[:action_time],
        :reference => hash[:reference],
        :description => hash[:description]
      }
      if b
        identity_hash.merge!(:bill_id => b.id)
      end
      identity_hash
    end  
  
    def self.update_hash( action_xml )
      hash = attrs( action_xml )
      update_hash = {
        :reference_label => hash[:reference_label]
      }
    end  
  
    def self.attrs( action_xml )
      if @attrs.blank?
        action_time = action_xml.get_attribute("date")
        action_time = Time.at(action_time.to_i) if action_time
        description = (action_xml/:text).inner_html if (action_xml/:text)
        ref = (action_xml/:reference).first if (action_xml/:reference)
        reference_label = ref.get_attribute("label") if ref
        reference = ref.get_attribute("ref") if ref
        @attrs = {
          :action_time =>     defined?(action_time) ? action_time : nil,
          :description =>     defined?(description) ? description : nil,
          :reference_label => defined?(reference_label) ? reference_label : nil ,
          :reference =>       defined?(reference) ? reference : nil 
        }
      end
      @attrs  
    end
  public    

end
