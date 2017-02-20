class Component::User::Entity
  class PasswordChanger < Grape::Entity
    expose(:identifier, documentation: {type: String})
  end

  class Lite < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:name, documentation: {type: String})
  end

  class PreJWT < Lite
    expose(:exp, documentation: {type: Integer}) do |_, _|
      1.week.from_now.to_i
    end
  end

  class JWT < Lite
    expose(:token, documentation: {type: String, desc: "frontend must request with header Authorization: JWT <this-token>"})
  end
end
