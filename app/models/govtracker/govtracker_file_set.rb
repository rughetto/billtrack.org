class GovtrackerFileSet
  extend GovtrackerCommon
  attr_reader :set_directory, :files
  attr_accessor :current, :marker, :tag
  
  # Initializes a set of GovtrackerFile objects with the file, and optional framing tag 
  # 
  # @param opts = {:dir => 'path', :tag => 'object_tag_name'} hash of options
  #     the :dir option is mandatory, but the :tag option just will intialize each file objects 
  #     in the set with the tag value. This should be used except in cases where different types
  #     of xml documents are stored in the set/directory
  # @return instance of GovtrackerFileSet
  def initialize( opts )
    raise ArgumentError, "Please specify a directory parameter :dir => 'path'" unless dir = opts[:dir]
    self.set_directory = dir
    self.tag = opts[:tag] 
    find_files
    self.marker = 0
    self.current = GovtrackerFile.new(:file => "#{set_directory}/#{files[marker]}", :tag => tag )
  end  
  
  def set_directory=( dir )
    @set_directory = dir.match(/^\//) ? dir : self.class.root_directory + dir
  end  
  
  def find_files
    Dir.chdir( set_directory )
    @files = Dir.glob( "*.xml" )
    raise ArgumentError, "No files found" if @files.blank?
    @files
  end  
  
  # ---------------------
  # Markers and other methods for iterating through files and creating 
  
  # Pulls the GovtrackerFile object related to the filename or file index number into @current  
  # doesn't reset the marker
  def []( index )
    index = get_index_from_file_name( index )if index.class == String
    file = self.files[index]
    self.current = GovtrackerFile.new(:file => "#{set_directory}/#{file}", :tag => @tag )
  end  
  
  def get_current
    self.current = GovtrackerFile.new(:file => "#{set_directory}/#{files[marker]}", :tag => @tag )
  end  
  
  def increment_marker
    self.marker = marker + 1 < files.size ? marker + 1 : files.size - 1
  end  
  
  def decrement_marker
    self.marker = marker - 1 >= 0  ? marker - 1 : 0
  end  
  
  
  def get_index_from_file_name( str )
    files.index( str ) || marker
  end  
  
  def next
    marker == increment_marker ? nil : get_current
  end  
  
  def previous
    marker == decrement_marker ? nil : get_current
  end  
  
  def rewind
    self.marker = 0
    get_current
  end  
  
end