require 'facter/core/resolution'
require 'facter/core/graph'

class Facter::Core::Resolution::Ordered < Facter::Core::Resolution

  def initialize(fact, name)
    super

    @initial = nil

    @actions = Facter::Core::Graph.new
  end

  def initial(new_initial)
    if @initial
      raise "Initial value for #{@name} already defined as #{@initial}; cannot redefine"
    else
      @initial = new_initial
    end
  end

  def resolve(name, opts = {}, &block)
    @actions[name] = Action.new(name, opts[:using], block)
  end

  def value
    sorted_actions.inject(@initial) do |accum, action|
      action.block.call(accum)
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

  def sorted_actions
    @actions.tsort.map { |name| @actions[name] }
  end
end
