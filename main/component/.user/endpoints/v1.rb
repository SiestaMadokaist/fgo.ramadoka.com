module Component::User::Endpoint; end
class Component::User::Endpoint::V1 < Ramadoka::Endpoint::Base
  use Warden::Manager do |manager|
    manager.failure_app = Component::User::Endpoint
  end

  class << self
    def paginated_response
      proc do |presenter, result, req|
        Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
      end
    end

    def normal_response
      proc do |presenter, result, _|
        Common::Primitive::Entity.show(data: result, presenter: presenter)
      end
    end

    def failure_response
      proc do |_, err, known_errors, _|
        error_pack  = known_errors
          .select{|c, m, p| m == err.class.name}
          .first
        if(error_pack.nil?)
          presenter = ERR::Presenter
        else
          code, _, presenter = error_pack
        end
        Common::Primitive::Entity.show(data: [err], code: code, error: true, presenter: presenter)
      end
    end
  end

  presenter(Component::User::Entity::Lite)
  error_presenter(ERR::Presenter)

  resource("/user")

  success(&normal_response)
  failure_response(&failure_response)

  def route_login
    require "pry"
    binding.pry
  end
  route!(:route_login) do
    path("/login")
    method(:get)
    description("login")
    error(ERR::NoAuthorization401)
    optional(:page, type: Integer, default: 1)
  end

end
