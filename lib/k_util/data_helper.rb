# frozen_string_literal: true

# Provide data object helper functions
module KUtil
  # Helper methods attached to the namespace for working with Data
  class DataHelper
    # Convert JSON string into to_open_struct but designed to work with a JSON string
    #
    # KUtil.data.parse_json(json, as: :symbolize_keys)
    # https://docs.ruby-lang.org/en/master/JSON.html
    # rubocop:disable Naming/MethodParameterName
    def parse_json(json, as: :hash)
      log.block(%i[hash hash_symbolized open_struct], title: 'Help as: ?') if as == :help

      case as
      when :hash
        JSON.parse(json)
      when :hash_symbolized, :symbolize_names, :symbolize_keys
        JSON.parse(json, symbolize_names: true)
      when :open_struct
        JSON.parse(json, object_class: OpenStruct)
      end
    end
    alias json_parse parse_json
    # rubocop:enable Naming/MethodParameterName

    # Convert various data types (Hash, Array, Struct) into a deep nested OpenStruct
    #
    # KUtil.data.to_open_struct(data)
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
    # KUtil.data.to_hash(data)
    def to_hash(data)
      # This nil check is only for the root object
      return {} if data.nil?

      return data.map { |value| hash_convertible?(value) ? to_hash(value) : value } if data.is_a?(Array)

      return to_hash(data.to_h) if !data.is_a?(Hash) && data.respond_to?(:to_h)

      data.each_pair.with_object({}) do |(key, value), hash|
        hash[key] = hash_convertible?(value) ? to_hash(value) : value
      end
    end
    # rubocop:enable Metrics/AbcSize,  Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def clean_symbol(value)
      return value if value.nil?

      value.is_a?(Symbol) ? value.to_s : value
    end

    # Convert a hash to a deep nested hash with symbolized keys
    # THIS CAME FROM CHAT GPT, I LIKE IT
    # def deep_transform_keys(hash)
    #   hash.each_with_object({}) do |(key, value), result|
    #     # Use the block if given, otherwise convert keys to symbols by default
    #     transformed_key = block_given? ? yield(key) : key.to_sym
        
    #     result[transformed_key] = case value
    #                               when Hash
    #                                 deep_transform_keys(value) { |k| block_given? ? yield(k) : k.to_sym }
    #                               when Array
    #                                 value.map { |v| v.is_a?(Hash) ? deep_transform_keys(v) { |k| block_given? ? yield(k) : k.to_sym } : v }
    #                               else
    #                                 value
    #                               end
    #   end
    # end

    def deep_symbolize_keys(input)
      return input if input.nil?

      return input unless input.is_a?(Hash)

      input.each_with_object({}) do |key_value, new_hash|
        key, value = key_value
        value = deep_symbolize_keys(value)                  if value.is_a?(Hash)
        value = value.map { |v| deep_symbolize_keys(v) }    if value.is_a?(Array)
        new_hash[key.to_sym] = value
      end
    end

    # def deep_symbolize_keys(hash)
    #   return hash if hash.nil?

    #   hash.transform_keys(&:to_sym)
    # end

    # Is the value a basic (aka primitive) type
    def basic_type?(value)
      value.is_a?(String) ||
        value.is_a?(Symbol) ||
        value.is_a?(FalseClass) ||
        value.is_a?(TrueClass) ||
        value.is_a?(Integer) ||
        value.is_a?(Float)
    end

    # Is the value a complex container type, but not a regular class.
    def hash_convertible?(value)
      # Nil is a special case, it responds to :to_h but generally
      # you only want to convert nil to {} in specific scenarios
      return false if value.nil?

      value.is_a?(Array) ||
        value.is_a?(Hash) ||
        value.is_a?(Struct) ||
        value.is_a?(OpenStruct) ||
        value.respond_to?(:to_h)
    end
  end
end
