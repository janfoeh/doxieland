module Doxieland
  module Actions
    class GetScan < ::Apidiesel::Action
      use Apidiesel::Handlers::ActionResponseProcessor
      use Handlers::FileRequest

      url ->(base_url, request) {
        base_url.path = request.parameters.delete(:path)

        base_url
      }

      http_method :get

      expects do
        string :path
      end
    end
  end
end