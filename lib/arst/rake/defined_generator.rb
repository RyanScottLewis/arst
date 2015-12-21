require "pathname"
require "arst/parser"
require "arst/generator"

module ARST
  module Rake
    # A generator defined within the rake task
    class DefinedGenerator
      def initialize(options)
        initialize_attributes(options)
      end

      # Get the name.
      #
      # @return [Symbol]
      attr_reader :name

      # Generate the files.
      #
      # @return [DefinedGenerator]
      def execute
        # TODO: Check if input_path is a valid ARST file
        # TODO: Check if output_path is a directory if split_files == true

        node = ARST::Parser.parse(@input_path.read)
        output = ARST::Generator.generate(@type, node, @options)

        write_files_from_generator_output(output)

        self
      rescue Parslet::ParseFailed => error
        puts error.cause.ascii_tree # TODO: DEBUG option or something
      end

      protected

      def initialize_attributes(options)
        @options = options.to_h

        @input_path = @options.delete(:input_path).to_s.strip
        @output_path = @options.delete(:output_path).to_s.strip

        raise ArgumentError, "invalid :input_path option" if @input_path.empty?
        raise ArgumentError, "invalid :output_path option" if @output_path.empty?

        @input_path = Pathname.new(@input_path)
        @output_path = Pathname.new(@output_path)

        @name = @options.delete(:name).to_sym unless @options[:name].nil?
        @type = @options.delete(:type).to_sym unless @options[:type].nil?

        @name ||= @input_path.basename(@input_path.extname).to_s # TODO: For tests: if "foo.arst" then "foo", if ".arst" then return ".arst". Works now but test anyways
        @type ||= :ruby
      end

      def write_files_from_generator_output(output)
        output.each do |output_file|
          file_path = @output_path.join(output_file[:filename])
          file_path.dirname.mkpath

          if file_path.exist?
            puts "[EXISTS] #{file_path}"
          else
            puts "[GENERATE] #{file_path}"
            file_path.open("w+") { |file| file.write(output_file[:body]) }
          end
        end
      end
    end
  end
end
