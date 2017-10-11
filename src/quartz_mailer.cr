require "smtp"
require "yaml"
require "kilt"

class Quartz::Mailer
  property client : SMTP::Client
  property message : SMTP::Message

  def initialize
    if url = ENV["SMTP_URL"]? || smtp_url
      if url.includes? ":"
        host, port = url.split(":")
      else
        host, port = url, "25"
      end

      @client = SMTP::Client.new(host, port.to_i)
      @message = SMTP::Message.new
    else
      raise "smtp url needs to be set in the config/mailer.yml or SMTP_URL environment variable"
    end
  end

  SMTP_YML = "config/mailer.yml"

  def smtp_url
    if File.exists?(SMTP_YML) &&
       (yaml = YAML.parse(File.read SMTP_YML)) &&
       (settings = yaml["smtp"])
      settings["url"].not_nil!.to_s
    end
  end

  def from(email : String = "", name : String = "")
    @message.from = SMTP::Address.new(email, name)
  end

  def to(email : String = "", name : String = "")
    @message.to << SMTP::Address.new(email, name)
  end

  def cc(email : String = "", name : String = "")
    @message.cc << SMTP::Address.new(email, name)
  end

  def bcc(email : String = "", name : String = "")
    @message.bcc << SMTP::Address.new(email, name)
  end

  def subject(@subject : String)
    @message.subject = @subject
  end

  def body(body : String)
    @message.body = body
  end

  # deliver the email
  def deliver
    if client = @client
      client.send @message
    end
  end

  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
