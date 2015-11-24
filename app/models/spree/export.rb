class Spree::Export < ActiveRecord::Base
  include GlobalID::Identification

  serialize :messages, Array
  serialize :filters, JSON

  has_attached_file :document
  do_not_validate_attachment_file_type :document

  state_machine :initial => :created do
    state :completed do
      # validates_attachment_presence :document
    end

    event :process do
      transition :created => :processing
    end

    event :complete do
      transition :processing => :completed
    end

    event :failure do
      transition :processing => :failed
    end

    event :stop do
      transition :created => :stopped
    end

    event :retry do
      transition :failed  => :processing, if: lambda {|export| !export.failed? }
      transition :stopped => :processing, if: lambda {|export| !export.stopped?}
    end

    after_transition to: :processing do  |export, transition|
      export.update_attribute :started_at, DateTime.now
    end

    after_transition to: [:completed, :failed, :stopped] do  |export, transition|
      export.update_attribute :finished_at, DateTime.now
    end
  end

  def status_icon
    case state
    when 'created' then return ''
    when 'processing' then return 'glyphicon-refresh gly-spin'
    when 'completed' then return 'glyphicon-ok'
    when 'failed' then return 'glyphicon-alert'
    when 'stopped' then return 'glyphicon-stop'
    else return ''
    end
  end

  def exporter_class
    Spree::ExporterCore::Config.exporters.select{|i| i.key.to_s == self.exporter.to_s}.first
  end
end
