class Component::User::Model < ActiveRecord::Base
  HMAC_SECRET = AuthParser::HMAC_SECRET
  HASH_METHOD = AuthParser::HASH_METHOD
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
