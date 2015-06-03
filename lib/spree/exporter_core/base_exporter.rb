module Spree
  module ExporterCore
    class BaseExporter
      def initialize export_id, options={}
        @export  = Spree::Export.find(export_id)

        @export.messages = []

        # Custom behavior
      end

      # Descriptive name for exporter
      def self.name
        Spree.t(:name, scope: [:exporter_core, :exporters, key])
      end

      # A unique key identifier for exporter
      def self.key
        self.to_s.gsub('Exporter', '').demodulize.underscore
      end

      # Load a file and the get data from each file row
      def process
        before_process

        begin
          @export.document = export_data

        rescue => e
          add_error message: e.message, backtrace: e.backtrace
        end

        after_process
      end

      # Load data to be exported
      def export_data
        raise "#{__FILE__}:#{__LINE__} You must define it"
      end

      private
        # Add errors to export
        #
        # @params
        #   message   => Error message
        #   backtrace => Error Bactrace
        def add_error(message:, backtrace:)
          @export.messages << {message: message, backtrace: backtrace}
        end

        # Set the export in progress
        def before_process
          @export.process unless @export.processing?
        end

        # Set the export as finished, either for completed or failed
        def after_process
          if @export.messages.nil? or @export.messages.empty?
            @export.complete unless @export.completed?
          else
            @export.failure unless @export.failed?
          end
        end
    end
  end
end
