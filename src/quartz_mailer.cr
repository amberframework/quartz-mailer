require "email"

class Quartz::Mailer
  VERSION = "0.4.0"

  def self.deliver(message : Message)
    config = Quartz.config

    if config.smtp_enabled
      EMail::Sender.new(
        config.smtp_address, config.smtp_port,
        use_tls: config.use_ssl
      ).start do
        enqueue message.to_email
      end
    else
      puts "SMTP Disabled, not actually sending email"
    end

  # TODO this doesn't actually stop the failure from killing the server
  rescue e : EMail::Error::MessageError
    puts "Email message couldn't be delivered."
    puts e.message
  end
end

require "./quartz_mailer/**"
