# Example on versioning system
# you can get it here by using:
# curl http://127.0.0.1:9292/user/register -X POST -d 'email=123' -H "Accept:application/vnd.fgo.ramadoka.com-v2+json"
class Component::User::Endpoints::V2::Web::Grape < Swaggerify::API

  Entity = Component::User::Entity
  DEFAULT_HTTP_CODES = []
  version("v2", using: :header, vendor: "fgo.ramadoka.com")
  resource("/user") do
    # TODO: http_codes
    # [error_code, error_name, error_presenter]
    desc("register via email", entity: Entity::Lite, http_codes: DEFAULT_HTTP_CODES)
    params do
      requires(:email, type: String)
    end
    post("/register") do
      raise ZeroDivisionError
    end
  end

end
