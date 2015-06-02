module Spree
  class ExportersConfiguration < Preferences::Configuration
    attr_accessor :exporters

    def initialize
      @exporters = []
    end
  end
end
