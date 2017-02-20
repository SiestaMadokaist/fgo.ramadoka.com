require("fakeredis")
class Component::User::PasswordChanger
  include Redis::Objects
  extend Memoist
  value(:password, expiration: 1.hour)
  value(:validation, expiration: 1.hour)

  attr_reader(:options)

  # @param options [Hash]
  # @option :user :required [User]
  # @option :uid :optional [String]
  def initialize(options = {})
    @options = _default_options.merge(options)
    init_validation!
  end

  def _default_options
    Hash[uid: SecureRandom.urlsafe_base64(6)]
  end
  memoize(:_default_options)

  def init_validation!
    if(self.validation.nil?)
      self.validation = SecureRandom.hex(3)
    end
  end

  class ValidationFailure < ERR::Forbidden403; end
  # @param options [Hash]
  # @option :validation [String]
  def validate!(options = {})
    raise ValidationFailure unless options[:validation] == validation.value
    return true
  end

  def uid
    @options[:uid]
  end

  def user
    @options[:user]
  end

  def identifier
    id
  end

  def id
    "#{user.id}-+-#{uid}"
  end

end
Component::User::PasswordChanger.redis = Redis.new
