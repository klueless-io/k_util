# frozen_string_literal: true

# module KDsl
#   # File utilities
#   module Util
#     class << self
#       attr_accessor :file
#     end

#     # Helper methods attached to the namespace for working with Files
#     class FileHelper
#       def self.expand_path(filename, base_path)
#         if pathname_absolute?(filename)
#           filename
#         elsif filename.start_with?('~/')
#           File.expand_path(filename)
#         else
#           File.expand_path(filename, base_path)
#         end
#       end

#       def self.pathname_absolute?(pathname)
#         Pathname.new(pathname).absolute?
#       end
#     end
#   end
# end

# KDsl::Util.file = KDsl::Util::FileHelper
