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

    it "defaults to port 25" do
      Quartz.reset_config
      Quartz.config.smtp_port.should eq 25
    end

    it "defaults to ssl disabled" do
      Quartz.reset_config
      Quartz.config.use_ssl.should be_false
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

      Quartz.reset_config

      Quartz.config.smtp_address = alternate_reality
      Quartz.config.smtp_address.should eq alternate_reality

      Quartz.config.smtp_port = mailcatcher_port
      Quartz.config.smtp_port.should eq mailcatcher_port

      Quartz.config.use_ssl = true
      Quartz.config.use_ssl.should eq true

      Quartz.config.smtp_enabled = true
      Quartz.config.smtp_enabled.should be_true

      Quartz.config.logger = happy_logger
      Quartz.config.logger.should eq happy_logger
    end
  end
end
