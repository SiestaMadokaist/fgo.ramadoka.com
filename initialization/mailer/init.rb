module Mailer
  delivery_options = Hash[
    address: ENV["FGO_SMTP_ADDRESS"],
    port: ENV["FGO_SMTP_PORT"],
    domain: ENV["FGO_SMTP_DOMAIN"],
    user_name: ENV["FGO_SMTP_USERNAME"],
    password: ENV["FGO_SMTP_PASSWORD"],
    authentication: "plain",
    enable_starttls_auto: true
  ]
  Mail.defaults do
    delivery_method(:smtp, delivery_options)
  end
end

class Mailer::Task
  def sender
    servant = servant_pools.shuffle.first
    "#{servant}@fgo.ramadoka.com"
  end


  def servant_pools
    [
      "arthuria",
      "mordred",
      "edmond"
    ]
  end

  def mail
    raise NotImplementedError
  end

  def subject
    raise NotImplementedError
  end

  def body
    raise NotImplementedError
  end
end

class Mailer::RequestPasswordChallenge < Mailer::Task

  extend Memoist
  # @param options [Hash]
  # @option :auth :required [Component::UserAuth::Email]
  def initialize(options = {})
    @options = options
  end

  def auth
    @options[:auth]
  end

  def raw_template
    File.read(File.expand_path("../templates/request_password_challenge.html", __FILE__))
  end
  memoize(:raw_template)

  def subject
    "test"
  end

  def template
    Erubis::Eruby.new(raw_template)
  end
  memoize(:template)

  def body
    template.result(auth: auth)
  end
  memoize(:body)

  def mail
    this = self
    Mail.new do
      to(this.auth[:origin_id])
      from(this.sender)
      subject(this.subject)
      html_part do
        content_type("text/html; charset=UTF-8")
        body(this.body)
      end
    end
  end

  def deliver!
    # mail.deliver!
    File.open("mail.html", "wb"){|f| f.write(body)}
  end

  memoize(:mail)

end
