class Component::UserAuth::Email < Component::UserAuth::Model
  class << self
    def default_scope
      where(origin: :email)
    end

    # @param email [String] (user's email)
    # @param password [String] (user's password before encript/hash)
    # @param name [String] (user's desired name, not necessary to be unique)
    # @return [Void]
    def register!(email, password, name)
      auth = new(origin: :email, origin_id: email)
      auth.user = Component::User::Model.new(name: name, password: password)
      auth.save!
      auth.user
    end

    # @param options [Hash]
    # options.*kwargs, anything queriable from this model
    def retrieve1!(options = {})
      result = get1(options)
      raise ERR::NotFound404 if result.nil?
      result
    end

  end
  enum(origin: origins)
  before_validation(:init_validator!, on: :create)
  before_save(:validate_email!)

  EmailRegex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def init_validator!
    self.validation_token = SecureRandom.urlsafe_base64
    self.validation_expiry = 1.day.from_now
  end


  class ValidationFailure < ERR::Forbidden403; end
  def validate!(pass)
    valid = user.password == Component::UserAuth::Model.hashify(pass)
    raise ValidationFailure, "unmatching password" unless valid
  end

  class WrongConstructor < ERR::ServerError503; end
  class PatternCheckFailure < ERR::Forbidden403; end
  def validate_email!
    raise WrongConstructor, to_json unless email?
    raise PatternCheckFailure, origin_id if EmailRegex.match(origin_id).nil?
    return true
  end

  def email
    origin_id
  end

  def to_basic_auth(password)
    str = "#{email}:#{password}"
    base64 = Base64.strict_encode64(str)
    "Basic #{base64}"
  end
end
