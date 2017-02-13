class Component::Material::Entity
  class Lite < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:name, documentation: {type: String})
    expose(:slug, documentation: {type: String})
  end
end
