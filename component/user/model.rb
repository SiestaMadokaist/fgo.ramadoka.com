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

  # @param options [Hash]
  # @option :validation :required [String]
  # @option :uid :required [String]
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

  def jwt_token
    JWT.encode pre_jwt, HMAC_SECRET, HASH_METHOD
  end

  def jwt_auth
    "JWT #{jwt_token}"
  end

  def pre_jwt
    Component::User::Entity::PreJWT
      .represent(self).as_json
  end
end
User = Component::User::Model
