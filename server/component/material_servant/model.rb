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

  def change_from
    return (servant.star + level) * 10 if ascension?
    return level if skill?
  end

  def next_level
    level + 1
  end

  def change_to
    return (servant.star + next_level) * 10 if ascension?
    return next_level if skill?
  end

  def _default_readable_format
    "%{classifier}| %{servant_name} %{change_from} => %{change_to}: %{material_name}x%{count}"
  end

  def _default_readable_formatter
    Hash[
      classifier: "%-10s",
      servant_name: "%-33s",
      change_from: "%-3i",
      change_to: "%-3i",
      material_name: "%-24s",
      count: "%-3s"
    ]
  end

  def readable(format = _default_readable_format, formatter = _default_readable_formatter)
    sfmt = format.gsub(/%{(\w+)}/){|match| "#\{formatter[:#{$1}]\}" }
    mmt = eval("\"#{sfmt}\"")
    keys = []
    format.scan(/%\{(\w+)\}/){|match| keys << eval(match[0]) }
    mmt % keys
  end

  def presented
    Component::MaterialServant::Entity::WithServant.represent(self).as_json
  end
end
