# frozen_string_literal: true

# Provide data object helper functions
module KUtil
  class << self
    attr_accessor :data
  end

  # Helper methods attached to the namespace for working with Data
  class DataHelper
    # Convert a hash into a deep OpenStruct or array an array
    # of objects into an array of OpenStruct
    def self.to_struct(data)
      case data
      when Hash
        OpenStruct.new(data.transform_values { |v| to_struct(v) })

      when Array
        data.map { |o| to_struct(o) }

      else
        # Some primitave type: String, True/False, Symbol or an ObjectStruct
        data
      end
    end

    def self.struct_to_hash(data)
      # No test yet
      if data.is_a?(Array)
        return data.map { |v| v.is_a?(OpenStruct) ? struct_to_hash(v) : v }
      end

      data.each_pair.with_object({}) do |(key, value), hash|
        case value
        when OpenStruct
          hash[key] = struct_to_hash(value)
        when Array
          # No test yet
          values = value.map { |v| v.is_a?(OpenStruct) ? struct_to_hash(v) : v }
          hash[key] = values
        else
          hash[key] = value
        end
      end
    end

    def self.clean_symbol(value)
      return value if value.nil?

      value.is_a?(Symbol) ? value.to_s : value
    end
  end
end

KUtil.data = KUtil::DataHelper
