module Quartz
  class Config
    property smtp_address = "127.0.0.1"
    property smtp_port = 25
    property use_ssl = false
    property smtp_enabled = false
    property logger : Logger

    def initialize
      @logger = Logger.new nil
    end
  end

  def self.config
    @@config ||= Config.new
  end

  def self.config(&block)
    yield config
  end
end
