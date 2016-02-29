module Doxieland
  class Client
    attr_reader :save_path

    def initialize(options)
      @options       = options
      @save_path     = Pathname.new(options[:to] || '.').expand_path
    end

    def api(&block)
      Doxieland::Api.url "http://#{scanner_ip}:8080"

      if @options[:password]
        Doxieland::Api.http_basic_auth 'doxie', @options[:password]
      end

      api = Doxieland::Api.new

      begin
        yield api
      rescue AuthenticationError => e
        puts e.message
        exit(false)
      end
    end

    def create_save_path
      raise ArgumentError, "#{@save_path} is a file" if @save_path.file?

      unless @save_path.directory? || @save_path == Pathname.new('.')
        FileUtils.mkdir_p(@save_path)
      end
    end

    def scanner_ip
      @scanner_ip ||= begin
        if @options['scanner-ip']
          @options['scanner-ip']
        elsif @options[:ap]
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
      end
    end

    def ssdp_discover
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

        message_sender.last
      end
    end
  end
end