module GovtrackerCommon
  def root_directory
    @root ||= "#{Merb.root}/schema/govtrack_us/"
  end
  
  def root_directory=( dir )
    @root = dir
  end  
  
  def current_session
    if @session.blank? 
      Dir.chdir(root_directory)
      @session = Dir.glob('[1][1-2][0-9]').map{|num| num.to_i }.max.to_s
    end
    @session  
  end
end  