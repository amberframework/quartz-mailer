# Quartz-Mailer

A library to get started in sending and receiving emails from and to your Crystal application

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  quartz-mailer:
    github: amber-crystal/quartz-mailer
```

## Usage

```crystal
require "quartz-mailer"
```

The mailer has the ability to set the `from`, `to`, `cc`, `bcc`, `subject` and `body`.
You may use the `render` helper to create the body of the email.

```crystal
class WelcomeMailer < Quartz::Mailer
  def initialize
    super
    from "Amber Crystal", "info@ambercr.io"
  end

  def deliver(name: String, email: String)
    to name: name, email: email
    subject "Welcome to Amber"
    body render("mailers/welcome_mailer.slang", "mailer.slang")
    super()
  end
end
```

To delivery a new email:
```crystal
mailer = WelcomeMailer.new
mailer.deliver(name, email)
```

## Contributing

1. Fork it ( https://github.com/amber-crystal/quartz-mailer/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
