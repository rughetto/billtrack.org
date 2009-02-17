require 'fileutils'
# Extension to make it easy to read and write data to a file.
# From Geoffrey Grossenbach's nearly identical rails fixturizing plugin
module Fixturizer
  module ActiveRecord
    def data_dump_location
      "schema/fixture_dump/"
    end 
  
    def fixture_dump_location
      "spec/fixtures/"
    end   
  
    # Writes all content by default, but can be limited.
    def dump_to_file(path=nil, limit=nil)
      opts = {}
      opts[:limit] = limit if limit
      FileUtils.mkdir_p data_dump_location
      path ||= "#{data_dump_location}/#{table_name}.yml"
      write_file(File.expand_path(path, Merb.root), self.find(:all, opts).to_yaml)
    end

    # Delete existing data in database and load fresh from file in db/table_name.yml
    def load_from_file(path=nil)
      path ||= "#{data_dump_location}/#{table_name}.yml"
      self.destroy_all

      if connection.respond_to?(:reset_pk_sequence!)
       connection.reset_pk_sequence!(table_name)
      end

      records = YAML::load( File.open( File.expand_path(path, Merb.root) ) )
      records.each do |rec|
        new_record = self.new
        rec.attributes.each do |key, val|
          new_record[key.to_s] = val
        end
        klass_col = rec.class.inheritance_column.to_sym
        if rec[klass_col]
           new_record[:type] = rec[klass_col]
        end
        new_record.save
      end    
      
      if connection.respond_to?(:reset_pk_sequence!)
       connection.reset_pk_sequence!(table_name)
      end
    end

    # Write a file that can be loaded with +fixture :some_table+ in tests.
    # Uses existing data in the database.
    #
    # Will be written to +test/fixtures/table_name.yml+. Can be restricted to some number of rows.
    def to_fixture(limit=nil)
      opts = {}
      opts[:limit] = limit if limit

      write_file(File.expand_path("spec/fixtures/#{table_name}.yml", Merb.root), 
          self.find(:all, opts).inject({}) { |hsh, record| 
              hsh.merge("#{table_name.singularize}_#{'%05i' % record.id rescue record.id}" => record.attributes) 
            }.to_yaml(:SortKeys => true))
      habtm_to_fixture
    end

    # Write the habtm association table
    def habtm_to_fixture
      joins = self.reflect_on_all_associations.select { |j|
        j.macro == :has_and_belongs_to_many
      }
      joins.each do |join|
        hsh = {}
        connection.select_all("SELECT * FROM #{join.options[:join_table]}").each_with_index { |record, i|
          hsh["join_#{'%05i' % i}"] = record
        }
        write_file(File.expand_path("#{fixture_dump_location}#{join.options[:join_table]}.yml", Merb.root), hsh.to_yaml(:SortKeys => true))
      end
    end
  
    # Generates a basic fixture file in test/fixtures that lists the table's field names.
    #
    # You can use it as a starting point for your own fixtures.
    #
    #  record_1:
    #    name:
    #    rating:
    #  record_2:
    #    name:
    #    rating:
    #
    # TODO Automatically add :id field if there is one.
    def to_skeleton
      record = { 
          "record_1" => self.new.attributes,
          "record_2" => self.new.attributes
         }
      write_file(File.expand_path("#{fixture_dump_location}#{table_name}.yml", Merb.root),
        record.to_yaml)
    end

    def write_file(path, content) # :nodoc:
      f = File.new(path, "w+")
      f.puts content
      f.close
    end
    
    # operates on subclasses too so ActiveRecord::Base.dump_all_to_file should dump all classes in app
    def load_all_from_file(base_path=nil)
      subclasses.each do |klass|
        if klass.base_class == klass
          klass.load_from_file(base_path)
          klass.rebuild! if klass.respond_to?(:rebuild!)
        end
      end  
    end
    
    def dump_all_to_file(base_path=nil)
      subclasses.each do |klass|
        if klass.base_class == klass
          klass.dump_to_file(base_path)
        end
      end
    end
     
  end  
    
end  


  