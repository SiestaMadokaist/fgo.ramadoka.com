module Swaggerify
  module Header
    Required = Hash[
      "Authorization" => Hash[
        required: true,
        description: "any kind of standard authorization"
      ]
    ]
    Optional = Hash[
      "Authorization" => Hash[
        required: false,
        description: "any kind of standard authorization"
      ]
    ]
  end

  def self.headers(level)
    return Header::Required if level == :required
    return Header::Optional if level == :optional
    raise ArgumentError, "#{level} level is not valid"
  end

  def headers(level)
    _headers(level)
  end

  def _headers(level)
    return Header::Required if level == :required
    return Header::Optional if level == :optional
    raise ArgumentError, "#{level} level is not valid"
  end
end

module Swaggerify::API; end
class Swaggerify::API::V1 < Grape::API
  class << self
    def inherited(subclass)
      vers = api_version
      super
      subclass.instance_eval do
        version(vers, using: :header, vendor: "fgo.ramadoka.com")
        format(:json)
        before do
          header["Access-Control-Allow-Origin"] = "*"
        end
      end
    end

    def api_version
      "v1"
    end

    def headers(level)
      Swaggerify.headers(level)
    end
  end
end

class Swaggerify::API::V2 < Swaggerify::API::V1
  def api_version
    "v2"
  end
end
