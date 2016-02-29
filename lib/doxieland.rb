require "doxieland/version"

require 'active_support/all'
require 'apidiesel'

require 'doxieland/handlers/file_request'
require 'doxieland/actions/list_scans'
require 'doxieland/actions/get_info'
require 'doxieland/api'
require 'doxieland/scan'

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
    scanner_ip = if options['scanner-ip']
      options['scanner-ip']
    elsif options[:ap]
      '192.168.1.100'
    else
      discovered_ip = ssdp_discover

      unless discovered_ip
        puts "… sorry, your scanner could not be found. Is WiFi turned on and the status light blue?"
        puts "If you know it, you can also provide the IP address manually via the --scanner-ip flag."
        exit
      end

      discovered_ip
    end

    Doxieland::Api.url "http://#{scanner_ip}:8080"
    Doxieland::Api.config :password, options[:password]

    api = Doxieland::Api.new

    begin
      yield api
    rescue AuthenticationError => e
      puts e.message
      exit
    end
  end

  def self.ssdp_discover
    socket = UDPSocket.new
    socket.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true
    socket.setsockopt :IPPROTO_IP, :IP_MULTICAST_TTL, 1

    query = [
      'M-SEARCH * HTTP/1.1',
      'HOST: 239.255.255.250:1900',
      'MAN: "ssdp:discover"',
      'ST: urn:schemas-getdoxie-com:device:Scanner:1',
      # 'ST: ssdp:all',
      'MX: 3',
      '',
      ''
    ].join("\r\n")

    puts "trying to find your scanner on the network. Here, Doxie Doxie…"

    socket.send(query, 0, '239.255.255.250', 1900)

    ready = IO.select([socket], nil, nil, 10)

    if ready
      _, message_sender = socket.recvfrom(65507)

      puts "found the little rascal! It was hiding at #{message_sender.last}"

      return message_sender.last
    end
  end
end
