class ExportJob < ActiveJob::Base
  queue_as :default

  def perform(export)
    export.exporter_class.new(export.id).process
  end
end
