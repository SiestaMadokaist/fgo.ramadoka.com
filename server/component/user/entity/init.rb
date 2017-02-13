class Component::User::Entity
  class Lite < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:name, documentation: {type: String})
  end
end
