module Spree
  module Admin
    class ExportsController < Spree::Admin::ResourceController
      before_action :set_exporter, raise: false

      # GET /admin/exporters/:exporter/exports
      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      # GET /admin/exporters/:exporter/exports/template
      def template
        file = File.open(@exporter.sample_file)

        send_data file.read, :filename => File.basename(@exporter.sample_file)
      end

      # GET /admin/exporters/:exporter_id/exports/new
      # default

      # POST /admin/exporters/:exporter_id/exports
      # default


      private
        def location_after_save
          ExportJob.perform_later @export
          admin_export_path(@export, exporter_id: @exporter.key)
        end

        def set_exporter
          @exporter = Spree::ExporterCore::Config.exporters.select{|exporter| exporter.key.to_s == params[:exporter_id].to_s}.first
        end

      protected
        def collection
          return @collection if @collection.present?

          @collection = super
          @collection = @collection.where(exporter: params[:exporter_id].to_s)
                                   .page(params[:page])
                                   .per(params[:per_page] || Spree::Config[:admin_products_per_page])
                                   .order(id: :desc)
        end
    end
  end
end
