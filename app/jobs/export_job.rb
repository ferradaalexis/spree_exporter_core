class ExportJob < ActiveJob::Base
  include ActiveWaiter::Job
  include Spree::Core::Engine.routes.url_helpers

  queue_as :default

  def perform(export)
    export.exporter_class.new(export.id).process

    20.times.each do |i|
      update_active_waiter percentage: (i+1) * 5
      sleep 1
    end

    admin_export_path(export, exporter_id: export.exporter_class.key)
  end
end
