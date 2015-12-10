require "pathname"
require "arst/parser"
require "arst/generator"

module ARST
  module Rake
    # A generator defined within the rake task
    class DefinedGenerator
      def initialize(options)
        options = validate_options(options)
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

        tree = ARST::Parser.parse(@input_path.read)
        output = ARST::Generator.generate(@type, tree, options)

        write_files_from_generator_output(output)

        self
      rescue Parslet::ParseFailed => error
        puts error.cause.ascii_tree # TODO: DEBUG option or something
      end

      protected

      def validate_options(options)
        options = options.to_h

        options[:input_path] = options[:input_path].to_s.strip
        options[:output_path] = options[:output_path].to_s.strip
        options[:name] = options[:name].to_sym unless options[:name].nil?
        options[:type] = options[:type].to_sym unless options[:name].nil?

        raise ArgumentError, "invalid :input_path option" if options[:input_path].nil?
        raise ArgumentError, "invalid :output_path option" if options[:output_path].nil?

        options
      end

      def initialize_attributes(options)
        @input_path = Pathname.new(options[:input_path])
        @output_path = Pathname.new(options[:output_path])
        @name = options[:name]
        @type = options[:type]

        @name ||= @input_path.basename(@input_path.extname).to_s # TODO: For tests: if "foo.arst" then "foo", if ".arst" then return ".arst". Works now but test anyways
        @type ||= :ruby
      end

      def write_files_from_generator_output(output)
        output.each do |data|
          file_path = output_path.join(data[:filename])
          file_path.dirname.mkpath

          if file_path.exist?
            puts "[EXISTS] #{file_path}"
          else
            puts "[GENERATE] #{file_path}"
            file_path.open("w+") { |file| file.write(data[:body]) }
          end
        end
      end
    end
  end
end
