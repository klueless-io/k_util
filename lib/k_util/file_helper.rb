# frozen_string_literal: true

# Provide file helper functions
module KUtil
  class << self
    attr_accessor :file
  end

  # Helper methods attached to the namespace for working with Files
  class FileHelper
    def self.expand_path(filename, base_path = nil)
      if pathname_absolute?(filename)
        filename
      elsif filename.start_with?('~/')
        File.expand_path(filename)
      else
        File.expand_path(filename, base_path)
      end
    end

    def self.pathname_absolute?(pathname)
      Pathname.new(pathname).absolute?
    end
  end
end

KUtil.file = KUtil::FileHelper
