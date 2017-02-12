class Component::MaterialServant::Model < ActiveRecord::Base
  class << self
    def name
      "MaterialServant"
    end
  end
  # before_save(:convert_classifier!)
  belongs_to(:material, class_name: "Component::Material::Model")
  belongs_to(:servant, class_name: "Component::Servant::Model")
  enum classifier: [ :ascension, :skill ]

  def material_name
    material.name
  end

  def servant_name
    servant.name
  end

  def presented
    Component::MaterialServant::Entity::WithServantName.represent(self).as_json
  end
end
