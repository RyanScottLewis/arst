require 'pathname'
require 'rake/tasklib'
require 'arst'

module ARST
  
  class RakeTask < Rake::TaskLib
    
    attr_reader :generators
    
    def initialize(&block)
      @generators = []
      
      block.call(self) if block_given?
      
      define_tasks
    end
    
    def add_generator(generator_options={})
      # TODO: Validate generator_options
      generators << generator_options
    end
    
    protected
    
    def define_tasks
      namespace :arst do
        desc 'Generate all ARST files'
        task :generate { @generators.each { |options| generate(options) } }
      end
    end
    
    def generate(options)
      # TODO: Validate options
      # TODO: Check if input_path is a valid ARST file
      # TODO: Check if output_path is a directory if split_files == true
      
      input_path = Pathname.new( options.delete(:input_path) )
      output_path = Pathname.new( options.delete(:output_path) )
      generator_type = options.delete(:type)
      
      tree = ARST::Parser.parse( input_path.read )
      output = ARST::Generator.generate( generator_type, tree, options )
      
      output.each do |output|
        file_path = output_path.join( output[:filename] )
        file_path.dirname.mkpath
        
        unless file_path.exist?
          puts "[GENERATE] #{file_path}"
          file_path.open('w+') { |file| file.write( output[:body] ) }
        else
          puts "[EXISTS] #{file_path}"
        end
      end
    end
    
  end
  
end
