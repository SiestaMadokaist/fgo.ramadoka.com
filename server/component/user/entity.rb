class Component::User::Entity
  class PreJWT < Grape::Entity
    expose(:id, documentation: {type: String})
    expose(:expires, documentation: {type: Integer}) do
      1.day.from_now
    end
  end

  class PJWT < PreJWT
    expose(:token, documentation: {type: String})
  end
end
