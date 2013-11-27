module Facter
  module Core
    class Resolution

      require 'facter/core/resolution/basic'
      require 'facter/core/resolution/ordered'

      attr_reader :name

      def initialize(fact, name)
        @fact = fact
        @name = name

        @confines = []
      end

      def clear
        true
      end

      def confine(args = {})
        args.each do |arg|
          @confines << arg
        end
      end

      def suitable?
        true
      end

      def resolve(*args)
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end

      include Comparable

      def <=>(other)
        other.weight <=> self.weight
      end

      def weight
        @confines.length
      end
    end
  end
end
