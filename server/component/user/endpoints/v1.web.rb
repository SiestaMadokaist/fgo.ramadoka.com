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
