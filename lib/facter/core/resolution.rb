require 'tsort'

module Facter
  module Core
    class Resolution

      attr_reader :name

      def initialize(fact, name)
        @fact = fact
        @name = name

        @confines = []

        @initial = nil

        @actions = Graph.new
      end

      def clear
        true
      end

      def initial(new_initial)
        if @initial
          raise "Initial value for #{@name} already defined as #{@initial}; cannot redefine"
        else
          @initial = new_initial
        end
      end

      def confine(args = {})
        args.each do |arg|
          @confines << arg
        end
      end

      def suitable?
        true
      end

      def resolve(name, opts = {}, &block)
        @actions[name] = Action.new(name, opts[:using], block)
      end

      def value
        sorted_actions.inject(@initial) do |accum, action|
          action.block.call(accum)
        end
      end

      include Comparable

      def <=>(other)
        other.weight <=> self.weight
      end

      def weight
        @confines.length
      end

      def sorted_actions
        @actions.tsort.map { |name| @actions[name] }
      end

      # Here at Puppet Labs, we fully endorse the use of graph theory to solve
      # all possible problems.
      #
      # @api WOOOOOO GRAPHS
      class Graph < Hash
        include TSort

        alias tsort_each_node each_key

        def tsort_each_child(node)
          fetch(node).deps.each do |child|
            yield child
          end
        end
      end

      class Action

        def initialize(name, deps, block)
          @name = name
          @deps = deps || []
          @block = block
        end

        attr_accessor :name, :deps, :block
      end
    end
  end
end
