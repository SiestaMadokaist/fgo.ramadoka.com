class Component::User::Endpoints
  class V1
    class Web < Grape::API
    end
  end
  require File.expand_path("../v1.web.rb", __FILE__)
end
