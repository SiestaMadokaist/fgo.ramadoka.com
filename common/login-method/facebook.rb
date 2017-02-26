class LoginMethod::Facebook< LoginMethod::Base
  VERSION = "v2.8"
  DialogEndpoint = "https://www.facebook.com/#{VERSION}/dialog/oauth"
  Site = "https://graph.facebook.com"
  TokenURL = "/oauth/access_token"
  Scope = ""
  UserInfoURL = "/me"
  Options = Hash[
    client_id: ENV["FGO_FB_CLIENT_ID"],
    client_secret: ENV["FGO_FB_CLIENT_SECRET"]
  ]
  class << self
    def client_kwargs
      Hash[
        site: Site,
        token_url: TokenURL
      ]
    end

    def client_id
      Options[:client_id]
    end

    def client_secret
      Options[:client_secret]
    end

    def user_info_url
      UserInfoURL
    end

    def scope
      Scope
    end

    def dialog_url(queries)
      Options
        .except(:client_secret)
        .merge(queries)
        .serialize(DialogEndpoint)
    end
  end

  def email
    e = _user_data[:email]
    return "#{_user_data[:id]}@facebook.com" if(e.blank?)
    return e
  end

  def avatar_url
    params = Hash[height: 200, width: 200]
    "#{Site}/#{VERSION}/#{_user_data[:id]}/picture#{params.serialize("")}"
  end

  def facebook_id
    _user_data[:id]
  end

  def facebook_name
    _user_data[:name]
  end

  EmailFacebookRegex = /\A\d+@facebook.com\z/
  def user_data
    # prefer to use ._user_data for local access
    # use .user_data for global access
    # not doing so might lead to mutual recursion
    ud = _user_data
    Hash[
      facebook: ud[:id],
      avatar_url: avatar_url,
      name: ud[:name],
      facebook_id: ud[:id]
    ]
  end
end
