class Component::MaterialServant::Entity
  class Lite < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:material, documentation: {type: Object})
    expose(:classifier, documentation: {type: String})
    expose(:count, documentation: {type: Integer})
  end
end
