require "./spec_helper"

describe Quartz::Mailer do
  it "loads settings from mailer.yml" do
    mailer = Quartz::Mailer.new
  end

  it "sets the from for the message" do
    mailer = Quartz::Mailer.new
    mailer.from "test@test.com"
    expect(mailer.message.from.not_nil!.email).to eq "test@test.com"
  end

  it "sets the to for the message" do
    mailer = Quartz::Mailer.new
    mailer.to "test@test.com"
    expect(mailer.message.to.first.not_nil!.email).to eq "test@test.com"
  end

  it "sets the cc for the message" do
    mailer = Quartz::Mailer.new
    mailer.cc "test@test.com"
    expect(mailer.message.cc.first.not_nil!.email).to eq "test@test.com"
  end

  it "sets the bcc for the message" do
    mailer = Quartz::Mailer.new
    mailer.bcc "test@test.com"
    expect(mailer.message.bcc.first.not_nil!.email).to eq "test@test.com"
  end

  it "sets the subject for the message" do
    mailer = Quartz::Mailer.new
    mailer.subject "subject"
    expect(mailer.message.subject).to eq "subject"
  end

  it "sets the subject for the message" do
    mailer = Quartz::Mailer.new
    mailer.body "body"
    expect(mailer.message.body).to eq "body"
  end
end

