require 'tsort'

module Facter
  module Core

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
  end
end
