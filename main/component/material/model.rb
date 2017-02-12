class Component::Material::Model < ActiveRecord::Base
  class << self
    def name
      "Material"
    end
  end
  has_many(:material_servants, class_name: "Component::MaterialServant::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :material_servants)
end
