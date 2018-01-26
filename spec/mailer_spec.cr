require "./spec_helper"

describe Quartz::Mailer do
  it "has a version" do
    Quartz::Mailer::VERSION.should be_a String
  end

  context "deliver" do
    it "doesnt try to connect when smtp is disabled" do
    end

    it "connects and sends when smtp is enabled" do
    end

    it "captures errors from EMail" do
    end
  end
end

