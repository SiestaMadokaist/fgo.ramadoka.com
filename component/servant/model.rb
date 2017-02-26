class Component::Servant::Model < ActiveRecord::Base
  class << self
    def name
      "Servant"
    end

    def klass
      [:shielder, :saber, :archer, :lancer, :rider, :caster, :assassin, :berserker, :ruler, :avenger, :beast]
    end

    def cached
      garner.options(expires_in: 5.minute) do
        select([:id, :name, :slug]).all
      end
    end

    def edit_distance(query)
      cached.map do |m|
        FED.new(m, query.downcase){|m| m.slug.downcase }
      end
    end

    def lookup(query, n = 5)
      raise QueryTooShort if query.length < 4
      edit_distance(query)
        .sort_by(&:distance)
        .reverse
        .take(n)
        .map(&:obj)
    end

  end
  enum(klass: klass)
  has_many(:material_servants, ->{ includes(:material) }, class_name: "Component::MaterialServant::Model")
  has_many(:materials, class_name: "Component::Material::Model", through: :material_servants)

  before_save(:init_slug!)

  def init_slug!
    self.slug = self.name.parameterize
  end

  def wiki_url
    "http://fategrandorder.wikia.com/wiki/#{name.gsub(" ", "_")}"
  end

end
Servant = Component::Servant::Model
