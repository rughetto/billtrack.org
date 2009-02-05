class GovtrackerFile
  extend GovtrackerCommon
  attr_accessor :tag
  
  # Initializes a set of GovtrackerFile objects with the file, and optional framing tag 
  # 
  # @param opts = {:file => 'path', :tag => 'object_tag_name'} hash of options
  #     The :file option is optional, but if not used the file= method must be called before real use.
  #     The :tag option is also optional and can be used to set the default tag name for searches
  # @return instance of GovtrackerFile object
  def initialize(opts={})
    self.file = opts[:file] if opts[:file]
    @tag = opts[:tag] if opts[:tag]
  end  
  
  def file
    @file || raise( ArgumentError, "no file provided to parse" )
  end  
  
  def file=( loc )
    loc = loc.match(/^\//) ? loc : self.class.root_directory + loc
    @file = File.read( loc )
  end
  
  def hpricoted
    Hpricot.parse( file )
  end
  
  def search(hash)
    hash = parse_hash( hash )
    hash[:hpricoted].search("//#{hash[:tag]}[@#{hash[:attribute]}='#{hash[:value]}']")
  end
  
  private
    def parse_hash( hash )
      hpr = hash.delete(:hpricoted)
      raise ArgumentError, "Hash size must be less than two" unless hash.size == 1
      key = hash.keys.first
      val = hash.values.first
      if val.class == Hash
        local_tag = key
        key = val.keys.first
        val = val.values.first
        raise ArgumentError, "Hash can only be nested one level deep" if val.class == Hash
      else
        local_tag = self.tag
      end    
      {
        :tag => local_tag,
        :attribute => key,
        :value => val,
        :hpricoted => hpr || self.hpricoted
      }  
    end
  public    
end
