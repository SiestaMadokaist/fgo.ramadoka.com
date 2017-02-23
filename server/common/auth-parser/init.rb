class AuthParser
  HMAC_SECRET = ENV["FGO_HMAC_SECRET"]
  HASH_METHOD = "HS256"
  def initialize(authorization)
    @authorization = authorization
  end

  def basic?
    @authorization.starts_with?("Basic")
  end

  def jwt?
    @authorization.starts_with?("JWT")
  end

  def parsed
    parsed_basic if basic?
    parsed_jwt if jwt?
  end

  private def parsed_jwt
    token = @authorization.split(" ").last.strip
    data, meta = JWT.decode(token, HMAC_SECRET, true, algorithm: HASH_METHOD)
    Hashie::Mash[data]
  end

  private def parsed_basic
    base64 = @authorization.split(" ").last.strip
    Base64.strict_decode64(base64).split(":")
  end
end
