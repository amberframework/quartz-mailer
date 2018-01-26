require "email"

class Quartz::Message
  alias Address = EMail::Address

  property from : Address?
  property to   = [] of Address
  property cc   = [] of Address
  property bcc  = [] of Address

  property subject = ""
  property text = ""
  property html = ""

  def self.address(email : String)
    Address.new email
  end

  def self.address(name : String, email : String)
    Address.new email, name
  end

  def from(email : String) : Nil
    @from = Message.address email
  end

  def from(name : String, email : String) : Nil
    @from = Message.address name, email
  end

  def from(@from : Address)
  end


  def bcc(email : String) : Nil
    @bcc << Message.address email
  end

  def bcc(name : String, email : String) : Nil
    @bcc << Message.address name, email
  end



  def cc(email : String) : Nil
    @cc << Message.address email
  end

  def cc(name : String, email : String) : Nil
    @cc << Message.address name, email
  end



  def to(email : String) : Nil
    @to << Message.address email
  end

  def to(name : String, email : String) : Nil
    @to << Message.address name, email
  end

  def subject(@subject : String) : Nil
  end

  def text(@text : String) : Nil
  end

  def html(@html : String) : Nil
  end

  # for backwards compatibility
  def body(@text : String) : Nil
  end

  def to_email
    EMail::Message.new.tap do |email|
      email.subject @subject

      if sender = @from
        email.from sender
      end

      unless @text.blank?
        email.message @text
      end

      unless @html.blank?
        email.message_html @html
      end

      @to.each do |person|
        email.to person
      end

      @cc.each do |person|
        email.cc person
      end

      @bcc.each do |person|
        email.bcc person
      end
    end
  end
end
