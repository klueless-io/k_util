# frozen_string_literal: true

# Provide console helper functions
module KUtil
  class << self
    attr_accessor :console
  end

  # Helper methods attached to the namespace for working with Console
  class ConsoleHelper
    # Convert a hash into a deep OpenStruct or array an array
    # of objects into an array of OpenStruct
    # Generate hyper link encoded string for the console
    def file_hyperlink(text, file)
      "\u001b]8;;file://#{file}\u0007#{text}\u001b]8;;\u0007"
    end

    def hyperlink(text, link)
      "\u001b]8;;#{link}\u0007#{text}\u001b]8;;\u0007"
    end
  end
end
