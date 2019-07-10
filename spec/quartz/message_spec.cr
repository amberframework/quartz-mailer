require "../spec_helper"

email = "testing@amberframework.org"
name = "Test Subject"
address = Quartz::Message.address name, email

email2 = "testing2@amberframework.org"
name2 = "Test Subject 2"
address2 = Quartz::Message.address name2, email2

subject = "hello"
text = "this is my email"
html = "<h1>this is my email</h1>"
header = ["X-Custom-Header", "Noice!"]

def build
  Quartz::Message.new
end

describe Quartz::Message do
  context "from field" do
    it "allows setting email without name" do
      message = build
      message.from email
      message._from.not_nil!.addr.should eq email
    end

    it "allows setting email with name" do
      message = build
      message.from name, email
      message._from.not_nil!.tap do |email_address|
        email_address.addr.should eq email
        email_address.name.should eq name
      end
    end

    it "allows setting email by Address object" do
      message = build
      message.from address
      message._from.not_nil!.tap do |email_address|
        email_address.addr.should eq address.addr
        email_address.name.should eq address.name
      end
    end

    it "allows setting from address by named parameters" do
      message = build
      message.from name: name, email: email
      message._from.not_nil!.tap do |email_address|
        email_address.addr.should eq email
        email_address.name.should eq name
      end
    end
  end

  context "destination" do
    {% for destination in ["to", "cc", "bcc"] %}
      {% destination = destination.id %}

      it "{{ destination }} allows setting destinations without name" do
        message = build
        message.{{ destination }} email
        message._{{ destination }}.size.should eq 1
        message._{{ destination }}.first.addr.should eq email
      end

      it "{{ destination }} allows setting destinations with name" do
        message = build
        message.{{ destination }} name, email
        message._{{ destination }}.size.should eq 1
        message._{{ destination }}.first.tap do |email_address|
          email_address.addr.should eq email
          email_address.name.should eq name
        end
      end

      it "{{ destination }} allows setting destinations by array" do
        message = build
        message.{{ destination }} [address, address2]

        message._{{ destination }}.size.should eq 2

        message._{{ destination }}[0].tap do |email_address|
          email_address.addr.should eq email
          email_address.name.should eq name
        end

        message._{{ destination }}[1].tap do |email_address|
          email_address.addr.should eq email2
          email_address.name.should eq name2
        end
      end

      it "{{ destination }} allows setting destination by named parameter" do
        message = build
        message.{{ destination }} name: name, email: email
        message._{{ destination }}.size.should eq 1
        message._{{ destination }}.first.tap do |email_address|
          email_address.addr.should eq email
          email_address.name.should eq name
        end
      end

      {% remove_method = "remove_#{destination}_recipient".id %}

      it "{{ remove_method }} allows removing destinations without name" do
        message = build

        message.{{ destination }} name: name, email: email
        message.{{ destination }} name: name2, email: email2

        message._{{ destination }}.size.should eq 2

        message.{{ remove_method }} email
        message._{{ destination }}.size.should eq 1
        message._{{ destination }}.first.addr.should eq email2
      end

      it "{{ remove_method }} allows removing destinations with name" do
        message = build

        message.{{ destination }} name: name, email: email
        message.{{ destination }} name: name2, email: email2

        message._{{ destination }}.size.should eq 2

        message.{{ remove_method }} name: name, email: email
        message._{{ destination }}.size.should eq 1
        message._{{ destination }}.first.addr.should eq email2
        message._{{ destination }}.first.name.should eq name2
      end

      it "{{ remove_method }} allows removing destinations by array" do
        message = build

        message.{{ destination }} [address, address2]
        message._{{ destination }}.size.should eq 2

        message.{{ remove_method }} [address2]
        message._{{ destination }}.size.should eq 1

        message._{{ destination }}[0].tap do |email_address|
          email_address.addr.should eq email
          email_address.name.should eq name
        end

        message.{{ destination }} [address2]
        message._{{ destination }}.size.should eq 2

        message.{{ remove_method }} [address, address2]
        message._{{ destination }}.size.should eq 0
      end

      it "{{ remove_method }} allows removing destination by named parameter" do
        message = build

        message.{{ destination }} name: name, email: email
        message.{{ destination }} name: name2, email: email2
        message._{{ destination }}.size.should eq 2

        message.{{ remove_method }} name: name, email: email
        message._{{ destination }}.size.should eq 1

        message._{{ destination }}[0].tap do |email_address|
          email_address.addr.should eq email2
          email_address.name.should eq name2
        end
      end
    {% end %}
  end

  context "subject field" do
    it "allows subject to be set" do
      message = build
      message.subject subject
      message._subject.should eq subject
    end
  end

  context "text body field" do
    it "allows the text body to be set" do
      message = build
      message.text text
      message._text.should eq text
    end

    it "allows the text body to be set with the #body method" do
      message = build
      message.body text
      message._text.should eq text
    end
  end

  context "html body field" do
    it "allows the html body to be set" do
      message = build
      message.html html
      message._html.should eq html
    end
  end

  context "custom header" do
    it "allows setting a custom header" do
      message = build
      message.header header[0], header[1]
      message._headers.size.should eq 1
      message._headers["X-Custom-Header"].should eq "Noice!"
    end
  end

  context "rendering an EMail" do
    it "renders the email" do
      message = build
      message.from address
      message.to address2
      message.subject subject
      message.text text
      message.html html
      message.to_email

      # EMail doesn't provide getters for the internal objects,
      # so we're just going to have to trust it?
    end
  end
end
