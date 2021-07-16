# frozen_string_literal: true

# Provide data object helper functions
module KUtil
  # Helper methods attached to the namespace for working with Data
  class DataHelper
    # Convert JSON string into to_open_struct but designed to work with a JSON string
    #
    # https://docs.ruby-lang.org/en/master/JSON.html
    # rubocop:disable Naming/MethodParameterName
    def json_parse(json, as: :hash)
      case as
      when :hash
        JSON.parse(json)
      when :hash_symbolized
        JSON.parse(json, symbolize_names: true)
      when :open_struct
        JSON.parse(json, object_class: OpenStruct)
      end
    end
    # rubocop:enable Naming/MethodParameterName

    # Convert various data types (Hash, Array, Struct) into a deep nested OpenStruct
    #
    # or an array of deep nested OpenStruct
    def to_open_struct(data)
      return OpenStruct.new(data.transform_values { |v| to_open_struct(v) })  if data.is_a?(Hash)
      return data.map { |o| to_open_struct(o) }                               if data.is_a?(Array)
      return to_open_struct(data.to_h)                                        if hash_convertible?(data)

      # Some primitave type: String, True/False or an ObjectStruct
      data
    end

    # rubocop:disable Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    # Convert data to hash and deal with mixed data types such as Struct and OpenStruct
    def to_hash(data)
      # This nil check is only for the root object
      return {} if data.nil?

      return data.map { |value| hash_convertible?(value) ? to_hash(value) : value } if data.is_a?(Array)

      return to_hash(data.to_h) if !data.is_a?(Hash) && data.respond_to?(:to_h)

      data.each_pair.with_object({}) do |(key, value), hash|
        hash[key] = if value.nil?
                      nil
                    else
                      hash_convertible?(value) ? to_hash(value) : value
                    end
      end
    end
    # rubocop:enable Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def clean_symbol(value)
      return value if value.nil?

      value.is_a?(Symbol) ? value.to_s : value
    end

    # Add if needed
    # # Is the value a basic (aka primitive) type
    # def basic_type?(value)
    #   value.is_a?(String) ||
    #     value.is_a?(Symbol) ||
    #     value.is_a?(FalseClass) ||
    #     value.is_a?(TrueClass) ||
    #     value.is_a?(Integer) ||
    #     value.is_a?(Float)
    # end

    # Is the value a complex container type, but not a regular class.
    def hash_convertible?(value)
      value.is_a?(Array) ||
        value.is_a?(Hash) ||
        value.is_a?(Struct) ||
        value.is_a?(OpenStruct) ||
        value.respond_to?(:to_h)
    end
  end
end
