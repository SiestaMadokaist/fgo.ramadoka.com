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
    # @return [Common::FED]
    def edit_distance(query)
      mats.map do |m|
        FED.new(m, query.downcase){|m| m.slug.downcase }
      end
    end

    class ERR::QueryTooShort < ERR::Forbidden403; end

    # @param query [String]
    # @param n [Integer]
    # @raise QueryTooShort
    # @return [Component::Material::Model]
    def lookup(query, n = 5)
      raise ERR::QueryTooShort if query.length < 4
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

  # called during (before_save)
  # @return void
  def init_slug!
    self.slug = self.name.parameterize
  end

  # @param user [Component::User::Model]
  # @return [Component::MaterialServant::Model]
  def usage_for(user)
    material_servants.includes(:servant).where(servant_id: user.servants.select([:id]))
  end

  # @return [String]
  def wiki_url
    _url = "http://fategrandorder.wikia.com/wiki/#{name}"
    URI.escape(_url)
  end

  def wiki
    Component::Material::Wiki.new(self)
  end
end
Material = Component::Material::Model

require File.expand_path("../image-downloader/init", __FILE__)
