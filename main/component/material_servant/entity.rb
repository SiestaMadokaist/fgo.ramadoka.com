class Component::MaterialServant::Entity
  class Lite < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:material_name, documentation: {type: Object})
    expose(:classifier, documentation: {type: String})
    expose(:count, documentation: {type: Integer})
    expose(:level, documentation: {type: Integer})
  end
  class WithServant < Lite
    expose(:servant_name, documentation: {type: String})
  end
end
