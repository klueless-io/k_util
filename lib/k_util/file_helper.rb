# frozen_string_literal: true

# Provide file helper functions
module KUtil
  # Helper methods attached to the namespace for working with Files
  class FileHelper
    def expand_path(filename, base_path = nil)
      if pathname_absolute?(filename)
        filename
      elsif filename.start_with?('~/')
        File.expand_path(filename)
      else
        File.expand_path(filename, base_path)
      end
    end

    def has_home?(path)
      path.start_with?('~/')
    end

    def pathname_absolute?(pathname)
      Pathname.new(pathname).absolute?
    end
  end
end
