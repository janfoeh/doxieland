module Doxieland
  module Actions
    class DeleteScans < ::Apidiesel::Action
      url path: '/scans/delete.json'

      http_method :post

      expects do
        object :paths, klass: Array
      end

      format_parameters do |params|
        params[:paths]
      end
    end
  end
end