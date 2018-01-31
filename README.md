# Quartz-Mailer

[![Build Status](https://travis-ci.org/amberframework/quartz-mailer.svg?branch=master)](https://travis-ci.org/amberframework/quartz-mailer)

A library to send emails from your Crystal application.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  quartz_mailer:
    github: amberframework/quartz-mailer
```

## Usage

```crystal
require "quartz_mailer"
```

The mailer has the ability to set the `from`, `to`, `cc`, `bcc`, and `subject` as well as both `text` and `html` body formats.

A `render` helper provides friendly markup rendering with [jeromegn/kilt](https://github.com/jeromegn/kilt).

```crystal
class WelcomeMailer < Quartz::Composer
  def sender
    address email: "info@amberframework.org", name: "Amber"
  end

  def initialize(name : String, email : String)
    to name: name, email: email
    subject "Welcome to Amber"
    text render("mailers/welcome_mailer.text.ecr")
    html render("mailers/welcome_mailer.html.slang", "mailer-layout.html.slang")
  end
end
```

To delivery a new email:
```crystal
WelcomeMailer.new(name, email).deliver
```

## Contributing

1. Fork it ( https://github.com/amber-crystal/quartz-mailer/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
