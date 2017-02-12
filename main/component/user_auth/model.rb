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
  end
  enum(origin: origins)
  belongs_to(:user, class_name: "Component::User::Model")

  def email?
    origin.to_sym == :email
  end
end

require File.expand_path("../email.model", __FILE__)
