require "../spec_helper"

module Quartz
  def self.reset_config
    @@config = Config.new
  end
end

describe Quartz::Config do
  context "smtp connection parameters" do
    it "defaults to localhost" do
      Quartz.reset_config
      Quartz.config.smtp_address.should eq "127.0.0.1"
    end

    it "defaults to port 1025" do
      Quartz.reset_config
      Quartz.config.smtp_port.should eq 1025
    end

    it "defaults to tls disabled" do
      Quartz.reset_config
      Quartz.config.use_tls.should be_false
    end

    it "defaults to openssl_verify_mode default (:peer)" do
      Quartz.reset_config
      Quartz.config.openssl_verify_mode.should eq OpenSSL::SSL::VerifyMode::PEER
    end

    it "defaults to authentication disabled" do
      Quartz.reset_config
      Quartz.config.use_authentication.should be_false
    end

    it "allows smtp_port to be set via string" do
      Quartz.reset_config
      Quartz.config.smtp_port = "25"
      Quartz.config.smtp_port.should eq 25
    end

    it "allows smtp_port to be set via int32" do
      Quartz.reset_config
      Quartz.config.smtp_port = 25_i32
      Quartz.config.smtp_port.should eq 25
    end

    it "defaults to username=nil" do
      Quartz.reset_config
      Quartz.config.username?.should be_nil
    end

    it "defaults to password=nil" do
      Quartz.reset_config
      Quartz.config.password?.should be_nil
    end

    it "raises when username is nil and tried to be read" do
      Quartz.reset_config
      expect_raises Exception do
        Quartz.config.username
      end
    end

    it "raises when password is nil and tried to be read" do
      Quartz.reset_config
      expect_raises Exception do
        Quartz.config.password
      end
    end
  end

  context "logger" do
    it "builds a default logger" do
      Quartz.reset_config
      Quartz.config.logger.should be_a Logger
    end
  end

  context "enable/disable" do
    it "defaults to disabled" do
      Quartz.reset_config
      Quartz.config.smtp_enabled.should be_false
    end
  end

  context "setting config parameters" do
    it "allows config settings to be changed" do
      alternate_reality = "127.1.1.1"
      mailcatcher_port = 1080
      happy_logger = Logger.new nil
      user = "me"
      password = "secrets"

      Quartz.reset_config

      Quartz.config.smtp_address = alternate_reality
      Quartz.config.smtp_address.should eq alternate_reality

      Quartz.config.smtp_port = mailcatcher_port
      Quartz.config.smtp_port.should eq mailcatcher_port

      Quartz.config.use_tls = true
      Quartz.config.use_tls.should eq true

      Quartz.config.openssl_verify_mode = :none
      Quartz.config.openssl_verify_mode.should eq OpenSSL::SSL::VerifyMode::NONE

      Quartz.config.smtp_enabled = true
      Quartz.config.smtp_enabled.should be_true

      Quartz.config.logger = happy_logger
      Quartz.config.logger.should eq happy_logger

      Quartz.config.use_authentication = true
      Quartz.config.use_authentication.should be_true

      Quartz.config.username = user
      Quartz.config.username.should eq user

      Quartz.config.password = password
      Quartz.config.password.should eq password
    end
  end
end
