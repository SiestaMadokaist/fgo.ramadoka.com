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
        before do
          header["Access-Control-Allow-Origin"] = "*"
        end
      end
    end

    def __vendor
      "fgo.ramadoka.com"
    end

    def __format
      "json"
    end

    # @param vers [Integer, Range]
    def produces(*vers)
      vers.map{|v| "application/vnd.#{__vendor}-v#{v}+#{__format}" }
    end

    def api_version
      "v1"
    end

    def headers(level)
      Swaggerify.headers(level)
    end
  end
end
