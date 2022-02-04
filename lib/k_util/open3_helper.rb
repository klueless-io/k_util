# frozen_string_literal: true

# Provide file helper functions
module KUtil
  # Helper methods attached to the namespace to run Open3 commands
  class Open3Helper
    def capture2(cmd, **opts)
      output, status = Open3.capture2(cmd, **opts)

      unless status.success?
        puts "failed to run command: #{cmd}"
        # bxxxinding.pry
      end

      raise Open3Error unless status.success?

      output
    end
  end
end
