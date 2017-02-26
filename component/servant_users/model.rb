class Component::ServantUser::Model < ActiveRecord::Base
  class << self
    def name
      "ServantUser"
    end
  end

  belongs_to(:user, class_name: "Component::User::Model")
  belongs_to(:servant, class_name: "Component::Servant::Model")
end
