require "doxieland/version"

require 'active_support/all'
require 'apidiesel'
require 'rainbow'
require 'open-uri'
require 'cgi'
require 'pathname'
require 'fileutils'

require 'doxieland/handlers/file_request'
require 'doxieland/actions/list_scans'
require 'doxieland/actions/get_info'
require 'doxieland/actions/get_scan'
require 'doxieland/actions/delete_scans'
require 'doxieland/api'
require 'doxieland/scan'
require 'doxieland/logger'
require 'doxieland/client'

module Doxieland
  class AuthenticationError < StandardError; end

  def self.config_path
    Pathname.new('~/.doxieland').expand_path
  end

  def self.config
    if File.file?(config_path)
      YAML.load( File.read(config_path) ).with_indifferent_access
    else
      HashWithIndifferentAccess.new
    end
  end
end
