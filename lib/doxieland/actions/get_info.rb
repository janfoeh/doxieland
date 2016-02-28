module Doxieland
  module Actions
    class GetInfo < ::Apidiesel::Action
      http_method :get
      url path: '/hello.json'
    end
  end
end