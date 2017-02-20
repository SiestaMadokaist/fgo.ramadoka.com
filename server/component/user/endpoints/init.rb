class Component::User::Endpoints
  module V1; end
  module V1::Web; end
  require File.expand_path("../v1.web.grape.rb", __FILE__)
  require File.expand_path("../v1.web.sinatra.rb", __FILE__)
end
