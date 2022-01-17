# frozen_string_literal: true

# Provide data object helper functions
# include KUtil::Data::InstanceVariablesToH
module KUtil
  module Data
    # Helper methods attached to the namespace for working with Data
    module InstanceVariablesToSymbolizedHash
      def to_h
        hash = {}
        instance_variables.each do |var|
          value = instance_variable_get(var)

          value = KUtil.data.to_hash(value) if KUtil.data.hash_convertible?(value)

          hash[var.to_s.delete('@').to_sym] = value
        end
        hash
      end
    end
  end
end
