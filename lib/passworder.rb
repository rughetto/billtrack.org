class Passworder
  def self.read(file)
    File.read( "#{Merb.root}/config/#{file}" )
  end  
end  