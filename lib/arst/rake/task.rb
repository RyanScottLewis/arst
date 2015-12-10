require "pathname"
require "rake/tasklib"
require "arst/rake/defined_generator"

module ARST
  module Rake
    # The Rake task for defining ARST generator tasks.
    class Task < ::Rake::TaskLib
      def initialize(&block)
        @generators = []

        block.call(self)

        define_tasks
      end

      # Define a new generator.
      #
      # @param [#to_h]
      # @return [Array<DefinedGenerator>]
      def add_generator(options={})
        defined_generator = DefinedGenerator.new(options)

        @generators << defined_generator

        namespace(:arst) do
          desc("Run the '#{defined_generator.name}' ARST generator")
          task(defined_generator.name) { defined_generator.execute }
        end
      end

      protected

      def define_tasks
        desc("Run all ARST generators")
        task(:arst) { @generators.each(&:execute) }
      end
    end
  end
end
