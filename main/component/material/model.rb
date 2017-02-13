require 'levenshtein'
class Component::Material::Model < ActiveRecord::Base
  class << self
    # @return [String]
    def name
      "Material"
    end

    # @return [Component::Material::Model]
    def mats
      Material.select([:id, :name, :slug])
    end

    # @param query [Component::Material::Model]
    # @return [FED]
    def edit_distance(query)
      mats.map do |m|
        FED.new(m, query.downcase){|m| m.slug.downcase }
      end
    end

    class QueryTooShort < ERR::Forbidden403; end

    # @param query [String]
    # @param n [Integer]
    # @raise QueryTooShort
    # @return [Component::Material::Model]
    def lookup(query, n = 5)
      raise QueryTooShort if query.length < 4
      edit_distance(query)
        .sort_by(&:distance)
        .reverse
        .take(n)
        .map(&:obj)
    end


  end
  has_many(:material_servants, class_name: "Component::MaterialServant::Model")
  has_many(:servants, class_name: "Component::Servant::Model", through: :material_servants)

  before_save(:init_slug!)

  # @callback to call during (before_save)
  # @return void
  def init_slug!
    self.slug = self.name.parameterize
  end

  # @param user [Component::User::Model]
  # @return void
  def usage_for(user)
    material_servants.includes(:servant).where(servant_id: user.servants.pluck(:id))
  end
end
Material = Component::Material::Model
