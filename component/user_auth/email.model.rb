class Component::UserAuth::Email < Component::UserAuth::Model
  extend Memoist
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
    # @option anything queriable from this model
    # TODO: deprecate maybe
    def retrieve1!(options = {})
      result = get1(options)
      raise ERR::NotFound404 if result.nil?
      result
    end

    # @param options [Hash]
    # @option :email :required [String]
    # @option :password :required [String]
    def login!(options = {})
      auth = get1(origin_id: options[:email])
      raise ERR::EmailNotFound if auth.nil?
      auth.validate!(password: options[:password])
      return auth
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


  # @param options [Hash]
  # @option :pass :required [String]
  def validate!(options = {})
    valid = user.password == Component::UserAuth::Model.hashify(password: options[:password])
    raise ERR::PasswordUnmatch, "unmatching password" unless valid
  end

  def validate_email!
    raise ERR::WrongConstructor, to_json unless email?
    raise ERR::PatternCheckFailure, origin_id if EmailRegex.match(origin_id).nil?
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

  # @param options [Hash]
  # @option :new_password :required [String]
  # unhashed user password
  # store new temporary password in redis
  # user must then enter validation code
  # that would be sent via email / phone
  # @return [Component::User::PasswordChanger]
  def set_new_password!(options = {})
    password_changer.password = Component::UserAuth::Model.hashify(password: options[:new_password])
  end

  # TODO:
  # send this via email
  # @param options [Hash]
  # @option :auth :required [Component::UserAuth::Email]
  def send_challenge_change_password!(options = {})
    pc = password_changer
    mailer = Mailer::RequestPasswordChallenge.new(auth: self)
    mailer.deliver!
  end


  # @return [Component::User::PasswordChanger]
  def password_changer
    Component::User::PasswordChanger.new(user: user)
  end
  memoize(:password_changer)
end
