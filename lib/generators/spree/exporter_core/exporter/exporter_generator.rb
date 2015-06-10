module Spree
  module ExporterCore
    module Generators
      class ExporterGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('../templates', __FILE__)

        def add_exporter_class
          template('exporter.rb', "lib/spree_exporter_core/#{file_name}_exporter.rb")
        end

        def add_locale
          inject_into_file 'config/locales/spree_exporter_core.en.yml', "
        #{file_name}:
          title: #{file_name.singularize.titleize} Exports
          name: #{file_name.titleize}", :after => "exporters:", :verbose => true
        end

        def add_to_exporters
          append_file 'config/initializers/spree.rb', "Spree::ExporterCore::Config.exporters << Spree::#{class_name}Exporter\n"
        end
      end
    end
  end
end
