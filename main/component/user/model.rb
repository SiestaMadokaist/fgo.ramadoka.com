class Component::User::Model < ActiveRecord::Base
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

  def material_lookup(material_name)
  end

end
User = Component::User::Model
