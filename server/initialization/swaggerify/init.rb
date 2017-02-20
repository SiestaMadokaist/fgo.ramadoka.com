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

class Swaggerify::API < Grape::API
  class << self
    def inherited(subclass)
      super
      subclass.instance_eval do
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
Swaggerify::API::V1 = Swaggerify::API
