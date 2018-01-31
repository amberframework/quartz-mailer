require "email"

class Quartz::Message
  alias Address = EMail::Address

  getter _from : Address?
  getter _to   = [] of Address
  getter _cc   = [] of Address
  getter _bcc  = [] of Address

  getter _subject = ""
  getter _text = ""
  getter _html = ""

  def self.address(email : String)
    Address.new email
  end

  def self.address(name : String, email : String)
    Address.new email, name
  end

  def from(email : String) : Nil
    from Message.address email
  end

  def from(name : String, email : String) : Nil
    from Message.address name, email
  end

  def from(@_from : Address)
  end

  {% for destination_field in [:to, :cc, :bcc] %}
    {% destination_field = destination_field.id %}

    def {{ destination_field }}(email : String) : Nil
      @_{{ destination_field }} << Message.address email
    end

    def {{ destination_field }}(name : String, email : String) : Nil
      @_{{ destination_field }} << Message.address name, email
    end

    def {{ destination_field }}(address : Address) : Nil
      @_{{ destination_field }} << address
    end

    def {{ destination_field }}(addresses : Array(Address)) : Nil
      addresses.each do |address|
        {{ destination_field }} address
      end
    end
  {% end %}

  def subject(@_subject : String) : Nil
  end

  def text(@_text : String) : Nil
  end

  def html(@_html : String) : Nil
  end

  # for backwards compatibility
  def body(@_text : String) : Nil
  end

  def to_email
    EMail::Message.new.tap do |email|
      email.subject @_subject

      if sender = @_from
        email.from sender
      end

      unless @_text.blank?
        email.message @_text
      end

      unless @_html.blank?
        email.message_html @_html
      end

      @_to.each do |person|
        email.to person
      end

      @_cc.each do |person|
        email.cc person
      end

      @_bcc.each do |person|
        email.bcc person
      end
    end
  end
end
