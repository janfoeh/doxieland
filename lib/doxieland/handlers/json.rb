module Doxieland
  module Handlers
    module JSON
      class RequestHandler
        include Apidiesel::Handlers::HttpRequestHelper

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
      end
    end
  end
end