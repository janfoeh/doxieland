module Doxieland
  module Handlers
    module FileRequest
      class RequestHandler
        include Apidiesel::Handlers::HttpRequestHelper

        def run(request, api_config)
          action = request.action

          request.metadata[:started_at] = DateTime.now

          execute_request(request: request,
                          payload: nil,
                          api_config: api_config)

          request.metadata[:finished_at] = DateTime.now

          image_number = request.http_request
                                .url
                                .path
                                .match(/[0-9]{4,}/)[0]

          request.result = Scan.from_api(request.response_body, image_number)

          request
        end
      end

      class ResponseHandler
        def run(request, api_config)
          image_number = request.http_request
                                .url
                                .path
                                .match(/[0-9]{4,}/)[0]

          request.result = Scan.from_api(request.response_body, image_number)

          request
        end
      end
    end
  end
end