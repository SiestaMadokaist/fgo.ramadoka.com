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
  def headers(level)
    return Header::Required if level == :required
    return Header::Optional if level == :optional
    raise ArgumentError, "#{level} level is not valid"
  end
end
