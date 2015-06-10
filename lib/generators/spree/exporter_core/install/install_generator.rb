module Spree
  module ExporterCore
    module Generators
      class InstallGenerator < Rails::Generators::Base

        class_option :auto_run_migrations, :type => :boolean, :default => false

        source_root File.expand_path('../templates', __FILE__)

        def add_javascripts
          append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_exporter_core\n"
          append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_exporter_core\n"
        end

        def add_stylesheets
          inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_exporter_core\n", :before => /\*\//, :verbose => true
          inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_exporter_core\n", :before => /\*\//, :verbose => true
        end

        def add_migrations
          run 'bundle exec rake railties:install:migrations FROM=spree_exporter_core'
        end

        def add_locale
          copy_file('spree_exporter_core.en.yml', 'config/locales/spree_exporter_core.en.yml')
        end

        def include_spree_exporter_core_from_lib
          inject_into_file 'config/application.rb', "# Load application's exporters
    Dir.glob(File.join(File.dirname(__FILE__), \"../lib/spree_exporter_core/*_exporter.rb\")) do |c|
      Rails.configuration.cache_classes ? require(c) : load(c)
    end\n\n    ", :before => "config.to_prepare do", :verbose => true
        end

        def run_migrations
          run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
          if run_migrations
            run 'bundle exec rake db:migrate'
          else
            puts 'Skipping rake db:migrate, don\'t forget to run it!'
          end
        end
      end
    end
  end
end
