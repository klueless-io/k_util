# frozen_string_literal: true

require 'k_util/version'
require 'k_util/console_helper'
require 'k_util/data_helper'
require 'k_util/file_helper'

# Provide various helper functions
module KUtil
  # raise KUtil::Error, 'Sample message'
  # class Error < StandardError; end

  class << self
    attr_accessor :console
    attr_accessor :data
    attr_accessor :file
  end

  KUtil.console = KUtil::ConsoleHelper.new
  KUtil.data = KUtil::DataHelper.new
  KUtil.file = KUtil::FileHelper.new
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KUtil::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_util/version') }
  version   = KUtil::VERSION.ljust(9)
  puts "#{namespace.ljust(40)} : #{version.ljust(9)} : #{file_path}"
end
