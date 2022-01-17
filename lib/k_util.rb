# frozen_string_literal: true

require 'open3'

require 'k_util/version'
require 'k_util/console_helper'
require 'k_util/data/instance_variables_to_h'
require 'k_util/data/instance_variables_to_symbolized_hash'
require 'k_util/data_helper'
require 'k_util/file_helper'
require 'k_util/open3_helper'

# Provide various helper functions
module KUtil
  # raise KUtil::Open3Error, 'Sample message'
  Open3Error = Class.new(StandardError)

  class << self
    attr_accessor :console
    attr_accessor :data
    attr_accessor :file
    attr_accessor :open3
  end

  KUtil.console = KUtil::ConsoleHelper.new
  KUtil.data = KUtil::DataHelper.new
  KUtil.file = KUtil::FileHelper.new
  KUtil.open3 = KUtil::Open3Helper.new
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KUtil::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_util/version') }
  version   = KUtil::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
