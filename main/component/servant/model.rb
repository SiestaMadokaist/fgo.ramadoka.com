class Component::Servant::Model < ActiveRecord::Base
  class << self
    def name
      "Servant"
    end

    def klass
      [:shielder, :saber, :archer, :lancer, :rider, :caster, :assassin, :berserker, :ruler, :avenger, :beast]
    end

  end
  enum(klass: klass)
  has_many(:material_servants, ->{ includes(:material) }, class_name: "Component::MaterialServant::Model")
  has_many(:materials, class_name: "Component::Material::Model", through: :material_servants)

  before_save(:init_slug!)

  def init_slug!
    self.slug = self.name.parameterize
  end
end
Servant = Component::Servant::Model
