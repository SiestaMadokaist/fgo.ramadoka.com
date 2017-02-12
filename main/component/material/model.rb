require 'levenshtein'
class Component::Material::Model < ActiveRecord::Base
  class << self
    def name
      "Material"
    end

    def mats
        Material.select([:id, :name, :slug])
    end

    def edit_distance(query)
      mats.map do |m|
        FED.new(m, query.downcase){|m| m.slug.downcase }
      end
    end

    def lookup(query, n = 5)
      edit_distance(query)
        .sort_by(&:distance)
        .reverse
        .take(n)
    end


  end
  has_many(:material_servants, class_name: "Component::MaterialServant::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :material_servants)

  before_save(:init_slug!)

  def init_slug!
    self.slug = self.name.parameterize
  end
  def usage_for(user)
    material_servants.includes(:servant).where(servant_id: user.servants.pluck(:id))
  end
end
Material = Component::Material::Model
