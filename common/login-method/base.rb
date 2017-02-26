class LoginMethod::Base
  extend Memoist

  def self.client_id=(id)
    @client_id = id
  end

  def self.client_secret=(secret)
    @client_secret = secret
  end

  def self.client_kwargs=(kwargs={})
    @client_kwargs = kwargs
  end

  def self.dialog_endpoint=(dialog_endpoint)
    @dialog_endpoint
  end

  def self.user_info_url=(user_info_url)
    @user_info_url = user_info_url
  end

  def self.scope=(scope)
    @scope = scope
  end

  def self.client_id
    @client_id
  end

  def self.scope
    @scope
  end

  def self.client_secret
    @client_secret
  end

  def self.client_kwargs
    @client_kwargs
  end

  def self.dialog_endpoint
    @dialog_endpoint
  end

  def self.user_info_url
    @user_info_url
  end

  def self._client
    OAuth2::Client.new(
      self.client_id,
      self.client_secret,
      self.client_kwargs
    )
  end

  def self.from_code(code, queries={})
    ac_token = _client
      .auth_code
      .get_token(code, queries)
    self.new(nil, ac_token)
  end


  attr_reader(:code, :ac_token)
  def initialize(code, ac_token=nil)
    @code = code
    @ac_token = ac_token
  end

  def _client
    self.class._client
  end
  memoize(:_client)

  def _access_token
    if(ac_token.nil?)
      OAuth2::AccessToken.new(_client, @code)
    else
      ac_token
    end
  end
  memoize(:_access_token)

  def has_valid_email?
    not email.nil?
  end

  def email
    raise NotImplementedError, "implement in the subclass please"
  end

  def _user_data
    response = _access_token.get(self.class.user_info_url)
    Hashie::Mash.new(JSON.parse(response.body))
  end
  memoize(:_user_data)

  def dialog_url(queries={})
    dialog_url.serialize(@dialog_endpoint)
  end

  def dialog_url_base_argument
    # TODO: still looks bad
    {
      client_id: self.class.client_id,
      scope: self.class.scope
    }.merge(self.class.client_kwargs)
  end

end
