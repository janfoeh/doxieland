module Doxieland
  module Actions
    class ListScans < ::Apidiesel::Action
      http_method :get
      url path: '/scans.json'
    end
  end
end