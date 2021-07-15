# frozen_string_literal: true

class CustomA
  attr :name

  def initialize(name:)
    @name = name
  end

  def to_h
    {
      name: @name
    }
  end
end

# class CustomA
#   attr :one
#   attr :two
#   attr :bs

#   def initialize
#     @bs = []
#   end

#   def to_json(*a)
#     { json_class: self.class.name,
#       one: @one,
#       two: @two,
#       three: @three,
#       bs: @bs }.to_json(*a)
#   end

#   def self.json_create(o)
#     a_from_json = new
#     a_from_json.one = o['one']
#     a_from_json.two = o['two']
#     a_from_json.bs = o['bs']
#     a_from_json
#   end
# end

# class CustomB
#   attr :x
#   attr :y
#   attr :z

#   def to_json(*a)
#     { json_class: self.class.name,
#       x: @x,
#       y: @y,
#       z: @z }.to_json(*a)
#   end

#   def self.json_create(o)
#     b_from_json = new
#     b_from_json.x = o['x']
#     b_from_json.y = o['y']
#     b_from_json.z = o['z']
#     b_from_json
#   end
# end
