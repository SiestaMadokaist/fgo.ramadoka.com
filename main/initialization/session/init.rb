module SessionHelper
  Warden::Manager.serialize_into_session{|user| Component::User.new }
  Warden::Strategies.add(:basic_auth) do

    def valid?
      true
    end

    def authenticate!
      user = Component::User.new
      success!(user)
    end
  end
end

