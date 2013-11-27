require 'facter/core/fact'

module Facter
  def self.fact(name)
    @facts ||= {}

    @facts[name] ||= Facter::Core::Fact.new(name)
  end

  def self.debug(*args)
    puts "FACTER DEBUG: #{args.inspect}"
  end

  def self.loadfacts
    @facts.inject({}) do |allfacts, (factname, fact)|
      allfacts[factname] = fact.value
      allfacts
    end
  end

  def self.print
    require 'json'
    puts JSON.pretty_generate(loadfacts)
  end
end
