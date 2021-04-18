# frozen_string_literal: true

# Provide data object helper functions
module KUtil
  module Data
    # Helper methods attached to the namespace for working with Data
    module InstanceVariablesToH
      def to_h
        hash = {}
        instance_variables.each do |var|
          value = instance_variable_get(var)

          value = KUtil.data.to_hash(value) if KUtil.data.hash_convertible?(value)

          hash[var.to_s.delete('@')] = value
        end
        hash
      end
    end
  end
end
