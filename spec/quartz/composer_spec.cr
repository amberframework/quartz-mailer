require "../spec_helper"

class ComposerTestMailer < Quartz::Composer
  def initialize
    subject "Foo Bar"
    to "foo@bar.com"
    cc "foo@bar.com"
    bcc "foo@bar.com"
    text "foobar_text"
    html "foobar_html"
  end

  def sender
    "foo@bar.com"
  end
end

composer = ComposerTestMailer.new

describe Quartz::Composer do
  {% for method in [:sender, :deliver, :address, :to, :cc, :bcc, :subject, :text, :body] %}
    {% method = method.id %}

    it "responds_to?({{method}})" do
      composer.responds_to?(:{{method}}).should(be_true)
    end
  {% end %}

  context "message" do
    it "has a message" do
      composer.@message.is_a?(Quartz::Message).should(be_true)
    end

    it "sets message attributes" do
      composer.@message._to.size.should eq(1)
      composer.@message._cc.size.should eq (1)
      composer.@message._bcc.size.should eq (1)
      composer.@message._subject.should eq ("Foo Bar")
      composer.@message._text.should eq ("foobar_text")
      composer.@message._html.should eq ("foobar_html")

      body_str = "foobar_body"
      composer.body body_str

      composer.@message._text.should eq(body_str)
    end
  end

  context "deliver" do
    it "sets the sender" do
      # composer.deliver ### deliver freezes the tests
      # composer.@message._from.should eq(composer.sender)
    end
  end

  context "render" do
    it "with_layout" do
      #render("composer_test_mailer.html.slang")
    end

    it "without_layout" do
      #render("composer_test_mailer.html.slang", "mailer_layout.html.slang")
    end
  end
end
