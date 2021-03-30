# frozen_string_literal: true

# module KDsl
#   # File utilities
#   module Util
#     class << self
#       attr_accessor :data
#     end

#     # Helper methods attached to the namespace for working with Data
#     class DataHelper
#       # Convert a hash into a deep OpenStruct or array an array
#       # of objects into an array of OpenStruct
#       def self.to_struct(data)
#         if data.is_a?(Hash)
#           return OpenStruct.new(data.map { |k,v| [k, to_struct(v)] }.to_h )

#         elsif data.is_a?(Array)
#           return data.map { |o| to_struct(o) }

#         else
#           # Some primitave type: String, True/False, Symbol or an ObjectStruct
#           return data
#         end
#       end

#       def self.struct_to_hash(data)
#         # No test yet
#         if data.is_a?(Array)
#           return data.map { |v| v.is_a?(OpenStruct) ? struct_to_hash(v) : v }
#         end

#         data.each_pair.with_object({}) do |(key, value), hash|
#           if value.is_a?(OpenStruct)
#             hash[key] = struct_to_hash(value)
#           elsif value.is_a?(Array)
#             # No test yet
#             values = value.map { |v| v.is_a?(OpenStruct) ? struct_to_hash(v) : v }
#             hash[key] = values
#           else
#             hash[key] = value
#           end
#         end
#       end

#       # Generate hyper link encoded string for the console
#       def self.console_file_hyperlink(text, file)
#         "\u001b]8;;file://#{file}\u0007#{text}\u001b]8;;\u0007"
#       end

#       def self.console_hyperlink(text, link)
#         "\u001b]8;;#{link}\u0007#{text}\u001b]8;;\u0007"
#       end

#       def self.clean_symbol(value)
#         return value if value.nil?

#         value.is_a?(Symbol) ? value.to_s : value
#       end
#     end
#   end
# end

# KDsl::Util.data = KDsl::Util::DataHelper
