# frozen_string_literal: true

# Provide data object helper functions
module KUtil
  # Helper methods attached to the namespace for working with Data
  class DataHelper
    # Convert various data types (Hash, Array, Struct) into a deep nested OpenStruct
    # or an array of deep nested OpenStruct
    def to_open_struct(data)
      case data
      when Hash
        OpenStruct.new(data.transform_values { |v| to_open_struct(v) })

      when Array
        data.map { |o| to_open_struct(o) }

      when Struct, OpenStruct
        to_open_struct(data.to_h)

      else
        # Some primitave type: String, True/False or an ObjectStruct
        data
      end
    end

    # rubocop:disable Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def to_hash(data)
      # No test yet
      if data.is_a?(Array)
        return data.map { |v| v.is_a?(OpenStruct) ? to_hash(v) : v }
      end

      return to_hash(data.to_h) if !data.is_a?(Hash) && data.respond_to?(:to_h)

      data.each_pair.with_object({}) do |(key, value), hash|
        case value
        when OpenStruct, Struct, Hash
          hash[key] = to_hash(value)
        when Array
          # No test yet
          values = value.map do |v|
            v.is_a?(OpenStruct) || v.is_a?(Struct) || v.is_a?(Hash) ? struct_to_hash(v) : v
          end
          hash[key] = values
        else
          hash[key] = value
        end
      end
    end
    # rubocop:enable Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def clean_symbol(value)
      return value if value.nil?

      value.is_a?(Symbol) ? value.to_s : value
    end
  end
end
