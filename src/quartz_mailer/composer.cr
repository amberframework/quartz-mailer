require "kilt"

class Quartz::Composer
  def sender
  end

  @message = Message.new

  delegate :to, :cc, :bcc, :subject, :text, :html, :body, to: @message
  delegate :address, to: Message

  def deliver
    @message.from sender
    Mailer.deliver @message
  end

  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
