class Component::User::Endpoints::V1::Web < Grape::API
  extend Swaggerify

  Entity = Component::User::Entity
  DEFAULT_HTTP_CODES = []


  resource("/user") do
    # TODO: http_codes
    # [error_code, error_name, error_presenter]
    desc("register via email", entity: Entity::Lite, http_codes: DEFAULT_HTTP_CODES)
    params do
      requires(:email, type: String)
      requires(:password, type: String)
      requires(:name, type: String)
    end
    post("/register") do
      user = Component::UserAuth::Email.register!(params[:email], params[:password], params[:name])
      Common::Primitive::Entity.show(data: user, presenter: Entity::Lite)
    end

    desc(
      "create a change_password request",
      entity: Entity::Lite,
      http_codes: DEFAULT_HTTP_CODES,
    )
    params do
      requires(:email, type: String, desc: "the user`s email")
      requires(:new_password, type: String, desc: "the user`s new password")
    end
    post("/change-password/email") do
      auth = Component::UserAuth::Email.retrieve1!(origin_id: params[:email])
      user = auth.user
      user.set_new_password!(new_password: params[:new_password])
      user.send_challenge_change_password!
      Common::Primitive::Entity
        .show(data: [user.password_changer], presenter: Component::User::Entity::PasswordChanger)
    end

    desc("enter the validation challenge code sent via email")
    params do
      requires(:identifier, type: String, desc: "key returned when an API call is made to /change-password/email")
      requires(:validation, type: String, desc: "the challenge validation code sent via email")
    end
    post("/validate-change-password/email") do
      user_id, uid = params[:identifier].split("-+-")
      user = User.get1(id: user_id.to_i)
      validation = params[:validation]
      user.validate_password_change!(validation: validation, uid: uid)
    end

    desc(
      "set servants",
      entity: Entity::Lite,
      http_codes: DEFAULT_HTTP_CODES,
      headers: headers(:required)
    )
    params do
      requires(:ids, type: Array, desc: "array of servant ids")
    end
    post("/servants") do
    end

  end


end
