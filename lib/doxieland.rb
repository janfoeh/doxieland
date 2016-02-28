require "doxieland/version"

require 'active_support/all'
require 'apidiesel'

require 'doxieland/handlers/json'
require 'doxieland/actions/list_scans'
require 'doxieland/api'

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

  def self.api(options, &block)
    Doxieland::Api.url "http://#{options['scanner-ip']}:8080"
    Doxieland::Api.config :password, options[:password]

    api = Doxieland::Api.new

    begin
      yield api
    rescue AuthenticationError => e
      puts e.message
      exit
    end
  end
end
