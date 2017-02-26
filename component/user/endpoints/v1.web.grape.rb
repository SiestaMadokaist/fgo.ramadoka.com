class Component::User::Endpoints::V1::Web::Grape < Swaggerify::API

  Entity = Component::User::Entity
  DEFAULT_HTTP_CODES = []
  version("v1", using: :header, vendor: __vendor)
  resource("/user") do
    # TODO: http_codes
    # [error_code, error_name, error_presenter]
    desc(
      "register via email",
      entity: Component::User::Entity::Lite,
      http_codes: DEFAULT_HTTP_CODES,
      produces: version(1)
    )
    params do
      requires(:email, type: String)
      requires(:password, type: String)
      requires(:name, type: String)
    end
    post("/register") do
      user = Component::UserAuth::Email.register!(params[:email], params[:password], params[:name])
      Common::Primitive::Entity.show(data: [user], presenter: Entity::Lite)
    end

    desc(
      "login with email",
      entity: Entity::Lite,
      http_codes: [
        ERR::PasswordUnmatch,
        ERR::EmailNotFound,
        ERR::PasswordTooShort
      ].map(&:desc),
      produces: version(1)
    )
    params do
      requires(:email, type: String)
      requires(:password, type: String)
    end
    post("/login") do
      dparams = declared(params)
      auth = Component::UserAuth::Email.login!(dparams)
      Common::Primitive::Entity.show(data: [user], presenter: Entity::Lite)
    end

    desc(
      "create a change_password request",
      entity: Common::Primitive::Entity,
      http_codes: DEFAULT_HTTP_CODES,
      produces: version(1)
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
        .show(data: [user.password_changer], presenter: Entity::PasswordChanger)
    end

    desc(
      "enter the validation challenge code sent via email",
      entity: Entity::Lite,
      produces: produces(1)
    )
    params do
      requires(:identifier, type: String, desc: "key returned when an API call is made to /change-password/email")
      requires(:validation, type: String, desc: "the challenge validation code sent via email")
    end
    post("/validate-change-password/email") do
      user_id, uid = params[:identifier].split("-+-")
      user = User.get1(id: user_id.to_i)
      validation = params[:validation]
      user.validate_password_change!(validation: validation, uid: uid)
      Common::Primitive::Entity
        .show(data: [Hash[success: true]])
    end

    desc(
      "parse jwt-token into json object",
      success: Entity::Lite,
      produces: version(1),
      headers: headers(:required)
    )
    post("/") do
      data = AuthParser.new(headers["Authorization"]).parsed
      Common::Primitive::Entity.show(data: [data], presenter: Entity::Lite)
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
