# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

class DryB < Dry::Struct
  attribute :name                 , Types::Coercible::String
end

class DryA < Dry::Struct
  attribute :name                 , Types::Coercible::String
  attribute :age                  , Types::Coercible::Integer
  attribute :list?                , Types::Strict::Array
  attribute :more                 , DryB
end
