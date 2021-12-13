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

    def home?(path)
      path.start_with?('~/')
    end

    def pathname_absolute?(pathname)
      Pathname.new(pathname).absolute?
    end
    alias absolute? pathname_absolute?

    def home_or_absolute?(path)
      home?(path) || absolute?(path)
    end

    def parse_uri(uri)
      return uri if uri.is_a?(URI)
      return URI.parse(uri) if uri =~ URI::ABS_URI # https://stackoverflow.com/questions/1805761/how-to-check-if-a-url-is-valid

      URI.join('file:///', uri)
    end
  end
end
