module Quartz
  class Config
    property smtp_address = "127.0.0.1"
    getter smtp_port = 1025

    property! username : String?
    property! password : String?
    property helo_domain : String? # = "domain_not_configured"

    property use_authentication = false
    property use_tls : EMail::Client::TLSMode = EMail::Client::TLSMode::NONE
    property openssl_verify_mode : OpenSSL::SSL::VerifyMode = :peer
    property smtp_enabled = false

    property logger : Logger

    def initialize
      @logger = Logger.new STDOUT
    end

    def smtp_port=(port : String)
      @smtp_port = port.to_i32
    end

    def smtp_port=(port : Number)
      @smtp_port = port.to_i32
    end
  end

  def self.config
    @@config ||= Config.new
  end

  def self.config(&block)
    yield config
  end
end
