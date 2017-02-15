class Component::User::Endpoints::V1::Web::Sinatra < Sinatra::Base
  def oauth_window(user)
    fpath = File.expand_path("../../views/token-window.erb", __FILE__)
    raw_template = File.read(fpath)
    template = Erubis::Eruby.new(raw_template)
    template.result(user)
  end

  get("/oauth/facebook/register") do
    if(params[:code].nil?)
      redirect(LoginMethod::Facebook.dialog_url(redirect_uri: request.uri))
    else
      fb = LoginMethod::Facebook.from_code(params[:code], redirect_uri: request.uri)
      user = Component::UserAuth::Facebook.register!(fb)
      oauth_window(user: user)
    end
  end

  get("/oauth/facebook/login") do
    if(params[:code].nil?)
      redirect(LoginMethod::Facebook.dialog_url(redirect_uri: request.uri))
    else
      fb = LoginMethod::Facebook.from_code(params[:code], redirect_uri: request.uri)
      user = Component::UserAuth::Facebook.login!(fb)
      oauth_window(user: user)
    end
  end
end
