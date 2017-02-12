class Component::UserAuth::Email < Component::UserAuth::Model
  class << self
    def default_scope
      where(origin: :email)
    end

    def register!(email, password, name)
      auth = new(origin: :email, origin_id: email)
      auth.user = Component::User::Model.new(name: name, password: hashify(password))
      auth.save!
      auth.user
    end

  end
  enum(origin: origins)
  before_validation(:init_validator!, on: :create)
  before_save(:validate_email!)

  class PatternCheckFailure < StandardError; end
  EmailRegex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def init_validator!
    self.validation_token = SecureRandom.urlsafe_base64
    self.validation_expiry = 1.day.from_now
  end

  def validate_email!
    raise WrongConstructor unless email?
    raise PatternCheckFailure if EmailRegex.match(origin_id).nil?
    return true
  end
end
