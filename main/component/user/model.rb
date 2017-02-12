class Component::User::Model < ActiveRecord::Base
  class << self
    def name
      "User"
    end
  end

  has_many(:servant_users, class_name: "Component::ServantUser::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :servant_users)
end
