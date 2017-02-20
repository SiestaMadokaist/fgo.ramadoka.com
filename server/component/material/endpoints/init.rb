require File.expand_path("../../../material_servant/init", __FILE__)
class Component::Material::Endpoints::V1::Web < Swaggerify::API::V1
  Entity = Component::Material::Entity
  extend Swaggerify

  resource("/material") do
    desc(
      "find similarly named material",
      headers: headers(:optional),
      entity: Entity::Lite,
    )
    params do
      requires(:query, type: String, desc: "must be greater or equal than 4 character")
      optional(:n, type: Integer, default: 5, desc: "will return only the top <n> result")
    end
    get("/lookup") do
      mats = Material.lookup(params[:query], params[:n])
      Common::Primitive::Entity.show(data: mats, presenter: Entity::Lite)
    end

    desc(
      "show usage for the user",
      headers: headers(:required),
      entity: Component::MaterialServant::Entity::WithServant
    )
    params do
      requires(:id, type: String, desc: "material-slug")
    end
    get("/:id/usage") do
      user = UserAuth.get_user(headers["Authorization"])
      mat = Material.find(params[:id])
      mat_serv = mat.usage_for(user)
      Common::Primitive::Entity.show(data: mat_serv, presenter: Component::MaterialServant::Entity::WithServant)
    end
  end
end
