# frozen_string_literal: true

class SymbolizedHashConvertible
  include KUtil::Data::InstanceVariablesToSymbolizedHash

  attr_accessor :key1
  attr_accessor :key2
  attr_accessor :key3
  attr_accessor :people

  def initialize(key1, key2, key3, people = [])
    @key1 = key1
    @key2 = key2
    @key3 = key3
    @people = people
  end
end
