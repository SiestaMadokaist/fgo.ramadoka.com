class Component::User::Model < ActiveRecord::Base
  HMAC_SECRET = AuthParser::HMAC_SECRET
  HASH_METHOD = AuthParser::HASH_METHOD

  extend Memoist
  class << self
    def name
      "User"
    end

    def email_register!(email, password, name)
      auth = UserAuth
      user = new(email: email, password: password, name: name)
      user.save!
      user
    end
  end


  has_many(:user_auths, class_name: "Component::UserAuth::Model")
  has_many(:servant_users, class_name: "Component::ServantUser::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :servant_users)

  before_validation(:ensure_password_hashed!)

  def ensure_password_hashed!
    return true if password_hashed?
    return true unless password_changed?
    self.password = Component::UserAuth::Model.hashify(password)
    @password_hashed = true
  end

  def password_hashed?
    return true if @password_hashed
    return false
  end

  def jwt_token
    JWT.encode pre_jwt, HMAC_SECRET, HASH_METHOD
  end

  def jwt_auth
    "JWT #{jwt_token}"
  end

  # @param options [Hash]
  # @option :new_password :required [String]
  # unhashed user password
  # store new temporary password in redis
  # user must then enter validation code
  # that would be sent via email / phone
  # @return [Component::User::PasswordChanger]
  def set_new_password!(options = {})
    password_changer.password = Component::UserAuth::Model.hashify(options[:new_password])
  end

  # TODO:
  # send this via email
  def send_challenge_change_password!
    puts(password_changer.validation.value)
  end

  # @param options [Hash]
  # @option validation :required [String]
  # @option uid :required [String]
  # @return [Void]
  def validate_password_change!(options = {})
    @password_hashed = true
    pc = Component::User::PasswordChanger.new(
      user: self,
      uid: options[:uid]
    )
    pc.validate!(validation: options[:validation])
    self.password = pc.password.value
    self.save!
  end

  # @return [Component::User::PasswordChanger]
  def password_changer
    Component::User::PasswordChanger.new(user: self)
  end
  memoize(:password_changer)

  def pre_jwt
    Component::User::Entity::PreJWT
      .represent(self).as_json
  end
end
User = Component::User::Model
