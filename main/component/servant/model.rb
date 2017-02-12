class Component::Servant::Model < ActiveRecord::Base
  class << self
    def name
      "Servant"
    end
  end
  has_many(:material_servants, class_name: "Component::MaterialServant::Model")
  has_many(:materials, class_name: "Component::Material::Model", through: :material_servants)

end
