require "parslet"
require "arst/node"

module ARST
  # The parser for ARST Notation.
  class Parser < Parslet::Parser
    class << self
      # Parse ARST Notation.
      #
      # @param [#to_s] input The body of the notation.
      # @return [Node::Root] ARST.
      def parse(input)
        new.parse(input)
      end
    end

    # Parse ARST Notation.
    #
    # @param [#to_s] input The body of the notation.
    # @return [Node::Root] ARST.
    def parse(input)
      root_node = Node::Root.new
      @current_scope = { depth: 0, node: root_node }

      lines = input.lines.collect { |line| super(line) }
      lines = sanitize_lines(lines)
      transform_lines(lines)

      @current_scope = nil

    # TODO: !!!!!!!!!!!!!!!!!!!
    # TODO: Classes do not show up in the tree oh nooooo oh fuck aw geez
    # TODO: !!!!!!!!!!!!!!!!!!!

      require "arst/generator/arst"
      puts input
      puts ?! * 80
      puts ?! * 80
      puts Generator::ARST.generate(root_node)


      root_node
    end

    rule(:space) { match('\s') }

    rule(:spaces) { space.repeat(1) }

    rule(:spaces?) { spaces.maybe }

    rule(:constant) { match("[A-Z]") >> match("[A-Za-z0-9_]").repeat }

    rule(:identifier) { match("[a-z_]") >> match("[A-Za-z0-9_]").repeat }

    rule(:namespace) { constant >> (str("::") >> constant).repeat(0) } # TODO: A constant which is not a module or class cannot have a ::

    rule(:module_keyword) { str("module").as(:type) >> spaces >> namespace.as(:name) }

    rule(:class_keyword) { str("class").as(:type) >> spaces >> namespace.as(:name) >> (spaces >> str("<") >> spaces >> namespace.as(:superclass)).maybe }

    rule(:include_keyword) { str("include").as(:type) >> spaces >> namespace.as(:name) }

    rule(:extend_keyword) { str("extend").as(:type) >> spaces >> namespace.as(:name) }

    rule(:def_keyword) { str("def").as(:type) >> space >> identifier.as(:name) >> spaces.maybe >> (str("(") >> (str(")").absent? >> any).repeat >> str(")")).as(:arguments).maybe } # TODO: Should we have rules for arglists? See: http://kschiess.github.io/parslet/get-started.html

    rule(:keyword) { module_keyword | class_keyword | include_keyword | extend_keyword | def_keyword }

    rule(:line) { space.repeat(0).as(:indentation) >> keyword.maybe >> spaces? }

    root(:line)

    protected

    def sanitize_lines(lines)
      lines.each_with_object([]) do |line, memo|
        next unless line.is_a?(Hash)

        line[:indentation] = line[:indentation].is_a?(Array) ? 0 : line[:indentation].to_s.length
        line[:indentation] -= 1 if line[:indentation].odd? # Quantize indentation to 2 spaces if needed
        line[:indentation] /= 2 # Convert space count to indentation depth

        # line[:indentation] = @current_scope[:depth] + 2 if line[:indentation] > @current_scope[:depth] + 2

        line[:type] = line[:type].to_sym

        memo << line
      end
    end

    def transform_lines(lines)
      lines.each do |line|
        depth = line.delete(:indentation)

        if depth > @current_scope[:depth]
          # @current_scope[:depth] += 1
          @current_scope[:node] = @current_scope[:node].children.reverse.find { |child| [Node::ModuleKeyword, Node::ClassKeyword].include?(child.class) }
        elsif depth < @current_scope[:depth]
          # @current_scope[:depth] -= 1
          @current_scope[:node] = @current_scope[:node].parent
        end

        case line[:type]
          when :module  then parse_module_or_class_keyword(line, depth)
          when :class   then parse_module_or_class_keyword(line, depth)
          when :include then @current_scope[:node].add_child(Node::IncludeKeyword.new(line))
          when :extend  then @current_scope[:node].add_child(Node::ExtendKeyword.new(line))
          when :def     then @current_scope[:node].add_child(Node::DefKeyword.new(line))
        end
      end
    end

    def parse_module_or_class_keyword(line, depth)
      node_class = { module: Node::ModuleKeyword, class: Node::ClassKeyword }[line[:type]]
      node = node_class.new(line)

      @current_scope[:depth] = depth
      @current_scope[:node].add_child(node)
    end
  end
end
