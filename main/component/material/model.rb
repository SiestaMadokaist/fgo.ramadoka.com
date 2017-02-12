class Component::Material::Model < ActiveRecord::Base
  class << self
    def name
      "Material"
    end
  end
  has_many(:material_servants, class_name: "Component::MaterialServant::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :material_servants)

  before_save(:init_slug!)

  def init_slug!
    self.slug = self.name.parameterize
  end
end
Material = Component::Material::Model
