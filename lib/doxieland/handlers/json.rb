module Doxieland
  module Handlers
    module JSON
      class RequestHandler
        def run(request, api_config)
          action = request.action

          payload = ::JSON.dump(request.parameters)

          request.metadata[:started_at] = DateTime.now

          execute_request(request: request,
                          payload: payload,
                          api_config: api_config)

          request.metadata[:finished_at] = DateTime.now

          request.response_body = ::JSON.parse(request.http_response.body)

          request
        end

        def execute_request(request:, payload:, api_config:)
          http_request      = HTTPI::Request.new(request.action.url.try(:to_s))
          http_request.body = payload

          unless api_config[:password].blank?
            http_request.auth.basic(api_config[:username], api_config[:password])
          end

          http_request.open_timeout = api_config[:timeout] || 30
          http_request.read_timeout = api_config[:timeout] || 30

          request.http_request = http_request

          begin
            response = HTTPI.request(request.action.http_method, http_request)
            request.http_response = response
          rescue => e
            raise Apidiesel::RequestError.new(e, request)
          end

          if response.error?
            if response.code == 401
              raise AuthenticationError, api_config[:password].blank? ? "Your Doxie requires a password to connect" : "Sorry, the password seems to be wrong"
            else
              raise Apidiesel::RequestError.new("#{request.action.http_method} #{request.action.url} returned #{response.code}", request)
            end
          end

          request
        end
      end
    end
  end
end