require "email"

class Quartz::Mailer
  def self.deliver(message : Message)
    config = Quartz.config

    unless config.smtp_enabled
      config.logger.warn "SMTP Disabled, not actually sending email."
      return
    end

    unless config.helo_domain
      config.logger.warn "HELO domain not configured, not sending email."
      return
    end

    if config.use_authentication
      connect_and_send(
        message,
        config.smtp_address,
        config.smtp_port,
        use_tls: config.use_tls,
        #logger: config.logger,
        helo_domain: config.helo_domain.not_nil!,
        auth: {config.username, config.password},
        #openssl_verify_mode: config.openssl_verify_mode
      )
    else
      connect_and_send(
        message,
        config.smtp_address,
        config.smtp_port,
        helo_domain: config.helo_domain.not_nil!,
        use_tls: config.use_tls,
        #openssl_verify_mode: config.openssl_verify_mode,
        #logger: config.logger,
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
