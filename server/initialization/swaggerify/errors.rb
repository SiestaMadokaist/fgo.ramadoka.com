module Swaggerify; end
module Swaggerify::Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ERR::CustomError do |e|
      headers = Hash[
        "Access-Control-Allow-Origin" =>  "*",
        "Access-Control-Allow-Method" => "GET, POST, HEAD, OPTIONS, DELETE, PUT, PATCH"
      ]
      entity = Common::Primitive::Entity.show(data: [e], error: true, presenter: ERR::Presenter)
      rack_response(entity.to_json, e.http_code, headers)
    end
  end
end

ERR.config!(fpath: "config/error-code.yml")
# TODO: use metaprogramming
class ERR::PasswordUnmatch < ERR::Forbidden403; end
class ERR::QueryTooShort < ERR::Forbidden403; end
class ERR::ValidationFailure < ERR::Forbidden403; end
class ERR::PasswordTooShort < ERR::Forbidden403; end
class ERR::PatternCheckFailure < ERR::Forbidden403; end

class ERR::EmailNotFound < ERR::NotFound404; end

class ERR::WrongConstructor < ERR::ServerError503; end
