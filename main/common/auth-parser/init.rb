class AuthParser
  def initialize(authorization)
    @authorization = authorization
  end

  def basic?
    @authorization.starts_with?("Basic")
  end

  def parsed
    parsed_basic if(basic?)
  end

  private def parsed_basic
    base64 = @authorization.split(" ").last.strip
    Base64.strict_decode64(base64).split(":")
  end
end
