require 'facter/core/resolution'

class Facter::Core::Resolution::Basic < Facter::Core::Resolution

  def initialize(fact, name)
    super

    @block = nil
  end

  def resolve(&block)
    @block = block
  end

  def value
    @block.call
  end

  def resolve_command(cmd)
    @block = proc { %x{#{cmd}}.chomp }
  end
end
