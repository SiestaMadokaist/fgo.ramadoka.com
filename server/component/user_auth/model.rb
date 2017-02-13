class Component::UserAuth::Model < ActiveRecord::Base
  SALT = "SILENCE-STRIKE-LIKE-A-HURRICANE"
  class << self
    def name
      "UserAuth"
    end
    def origins
      [ :email, :facebook, :google, :github, :account_ki, ]
    end
    def hashify(password)
      Digest::SHA1.hexdigest("#{SALT}:#{password}")
    end

    def get_user(authorization)
      email, pass = AuthParser.new(authorization)
        .parsed
      auth = Component::UserAuth::Email.get1(origin_id: email)
      auth.validate!(pass)
      auth.user
    end
  end
  enum(origin: origins)
  belongs_to(:user, class_name: "Component::User::Model")

  def email?
    origin.to_sym == :email
  end

  def as_email
    raise ArgumentError, "trying to convert non-email-authorization into Component::UserAuth::Email" unless email?
    Component::UserAuth::Email.find(id)
  end

end

UserAuth = Component::UserAuth::Model
