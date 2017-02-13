class Component::User::Endpoints::V1::Web < Grape::API
  Entity = Component::User::Entity
  resource("/user") do
    # TODO: http_codes
    # [error_code, error_name, error_presenter]
    desc("register via email", entity: Entity::Lite, http_codes: [])
    params do
      requires(:email, type: String)
      requires(:password, type: String)
      requires(:name, type: String)
    end
    post("/register") do
      user = Component::UserAuth::Email.register!(params[:email], params[:password], params[:name])
      Common::Primitive::Entity.show(data: user, presenter: Entity::Lite)
    end
  end


end
