require "log"
require "email"

class Quartz::Mailer
  Log = Log.for(self)

  def self.deliver(message : Message)
    config = Quartz.config

    unless config.smtp_enabled
      Log.warn { "SMTP Disabled, not actually sending email." }
      return
    end

    if config.use_authentication
      connect_and_send(
        message,
        config.smtp_address,
        config.smtp_port,
        use_tls: config.use_tls,
        auth: {config.username, config.password},
        openssl_verify_mode: config.openssl_verify_mode
      )
    else
      connect_and_send(
        message,
        config.smtp_address,
        config.smtp_port,
        use_tls: config.use_tls,
        openssl_verify_mode: config.openssl_verify_mode,
      )
    end
  end

  private def self.connect_and_send(message : Message, smtp_address : String, smtp_port : Int32, **connection_options)
    EMail::Sender.new(
      smtp_address, smtp_port,
      **connection_options
    ).start do
      enqueue message.to_email
    end
  end
end

require "./quartz_mailer/**"
