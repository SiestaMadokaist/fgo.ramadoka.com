class Component::User::Entity
  class PasswordChanger < Grape::Entity
    expose(:identifier, documentation: {type: String})
  end

  class User < Grape::Entity
    expose(:id, documentation: {type: Integer})
    expose(:name, documentation: {type: String})
  end

  class PreJWT < User
    expose(:exp, documentation: {type: Integer}) do |_, _|
      1.week.from_now.to_i
    end
  end

  class JWT < User
    expose(:jwt_token, documentation: {type: String, desc: "frontend must request with header Authorization: JWT <this-token>"})
  end

  Lite = User
end
