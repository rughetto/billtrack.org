class BillVote < BillAction
  
  def self.import( action_xml, b )
    record = find_or_create_by( identity_hash( action_xml, b ) )
    record.update_attributes( update_hash( action_xml ) )
    @attrs = nil # clear class level instance variables for use with next record
    @vote_attrs = nil 
    record
  end
  
  private
    def self.attrs( action_xml )
      if @vote_attrs.blank?
        vote_result = action_xml.get_attribute('result')
        vote_method = action_xml.get_attribute('how')
        @vote_attrs = {
          :type => 'BillVote',
          :vote_result => vote_result,
          :vote_method => vote_method
        }
        # merge vote related attibutes into @attrs
        super( action_xml )
        @attrs.merge!(@vote_attrs)
      end  
      @attrs
    end  
    
    def self.identity_hash( action_xml, b)
      hash = super( action_xml, b)
      hash.merge!({
        :type => attrs( action_xml )[:type],
        :vote_result => attrs( action_xml )[:vote_result]
      })
    end  
  
    def self.update_hash( action_xml )
      hash = super( action_xml )
      hash.merge!({
        :vote_method => attrs( action_xml )[:vote_method]
      })
    end
  public  
    
  
end  