class Component::UserAuth::Facebook < Component::UserAuth::Model
  class << self
    def default_scope
      where(origin: :facebook)
    end

    def login!(fb)
      auth = get1(origin_id: fb.facebook_id)
      raise UnregisteredUser, "no auth found facebook: #{fb.facebook_id}" if auth.nil?
      raise UnregisteredUser, "weird, no user found: #{fb.facebook_id}" if auth.nil?
      auth.user;
    end

    # @param fb [LoginMethod::Facebook]
    # @param password [String]
    def register!(fb, password = SecureRandom.urlsafe_base64)
      auth = new(origin: :facebook, origin_id: fb.facebook_id)
      auth.user = Component::User::Model.new(name: fb.facebook_name, password: hashify(password))
      auth.save!
      return auth.user
    end
  end
end
