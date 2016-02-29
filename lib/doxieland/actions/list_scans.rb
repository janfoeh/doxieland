module Doxieland
  module Actions
    class ListScans < ::Apidiesel::Action
      http_method :get
      url path: '/scans.json'

      responds_with do
        array do
          string :path,
                  at: :name,
                  filter: ->(s) { "/scans#{s}" }
          string :thumbnail_path,
                  at: :name,
                  filter: ->(s) { "/thumbnails#{s}" }
          string :name,
                  filter: ->(s) { s.match(/[0-9]{4,}/)[0] }
          integer :size
        end
      end
    end
  end
end