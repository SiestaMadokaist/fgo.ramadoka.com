class Component::UserAuth::Model < ActiveRecord::Base
  SALT = "SILENCE-STRIKE-LIKE-A-HURRICANE"
  class ERR::PasswordTooShort < ERR::Forbidden403; end
  class << self
    def name
      "UserAuth"
    end

    def origins
      [ :email, :facebook, :google, :github, :account_ki, ]
    end

    # @param options [Hash]
    # @option :password :required [String]
    def hashify(options = {})
      password = options[:password]
      raise ERR::PasswordTooShort, "password must be 6 character or longer" unless password.length >= 6
      Digest::SHA1.hexdigest("#{SALT}:#{password}")
    end

    # TODO: handle both authorization from JWT and Basic
    # or just handle JWT
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
