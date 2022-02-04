# frozen_string_literal: true

# Provide data object helper functions
# include KUtil::Data::InstanceVariablesToH
module KUtil
  module Data
    # Helper methods attached to the namespace for working with Data
    module InstanceVariablesToH
      def to_h(symbolize_keys: false)
        hash = {}
        instance_variables.each do |var|
          value = instance_variable_get(var)

          # TODO: Add deep support for symbolize_keys
          value = KUtil.data.to_hash(value) if KUtil.data.hash_convertible?(value)

          key = var.to_s.delete('@')
          key = key.to_sym if symbolize_keys

          hash[key] = value
        end
        hash
      end
    end
  end
end
