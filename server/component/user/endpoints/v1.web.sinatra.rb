class Component::User::Endpoints::V1::Web::Sinatra < Sinatra::Base
  get("/oauth/facebook/register") do
    if(params[:code].nil?)
      redirect(LoginMethod::Facebook.dialog_url(redirect_uri: request.uri))
    else
      fb = LoginMethod::Facebook.from_code(params[:code], redirect_uri: request.uri)
      user = Component::UserAuth::Facebook.register!(fb)
    end
  end

  get("/oauth/facebook/login") do
    if(params[:code].nil?)
      redirect(LoginMethod::Facebook.dialog_url(redirect_uri: request.uri))
    else
      fb = LoginMethod::Facebook.from_code(params[:code], redirect_uri: request.uri)
      user = Component::UserAuth::Facebook.login!(fb)
    end
  end
end
